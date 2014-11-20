require 'logger'
require 'octokit'
require 'active_support/core_ext/hash'
require 'active_record'

module DBSupplier
  class Migrator
    class << self
      def configurations
        @configurations
      end

      def configurations=(config={})
        @configurations = config

        @schema_repository = config[:schema_repository]
        @schema_ref        = config[:schema_ref] || 'master'
        @schema_files      = config[:schema_files].symbolize_keys
        @access_token      = config[:access_token]

        @github_api_endpoint = config[:github_api_endpoint]

        @logger = config[:logger] || Logger.new(STDOUT)
      end

      def migrate
        @logger.info "----- migrate start -----"

        databases.each do |database|
          @logger.info "----- #{database} migrate start -----"

          if (ActiveRecord.const_defined?(:Import))
            connection = ActiveRecord::Base.establish_connection_without_activerecord_import(database).connection
          else
            connection = ActiveRecord::Base.establish_connection(database).connection
          end

          @logger.debug "----- connected -----"

          sqls = fetch_sql(database)
          sqls.each do |sql|
            statements = sql.split(/;/)

            statements.each do |query|
              next if query == "\n\n"

              @logger.debug "----- query execute -----"
              connection.execute(query)
              @logger.debug query
              @logger.debug "----- query success -----"
            end
          end

          @logger.info "----- #{database} migrate finished -----"
        end

        @logger.info "----- migrate finished -----"
      end

      def fetch_sql(db_name)
        migration_file_paths = @schema_files.try(:fetch, db_name.to_sym) || (raise RuntimeError, "undefined #{db_name} schemat")
        repository = @schema_repository || (raise RuntimeError, 'undefined schema repository')

        Array(migration_file_paths).map do |path|
          client.contents(
            repository,
            ref: @schema_ref,
            path: path,
            headers: {
              accept: 'application/vnd.github.VERSION.raw'
            }
          )
        end
      end

      def show_sqls(db_name=nil)
        return fetch_sql(db_name) if db_name

        sqls = databases.map do |db_name|
          fetch_sql(db_name)
        end

        return sqls.join("\n")
      end

      def client
        ac = @access_token || ENV['GITHUB_ACCESS_TOKEN'] || (raise RuntimeError, 'undefined access_token')

        @client ||= begin
                      Octokit.api_endpoint = @github_api_endpoint if @github_api_endpoint
                      Octokit::Client.new(access_token: ac)
                    end
      end

      def databases
        @schema_files.try(:keys) || []
      end
    end
  end

end
