namespace :db do
  namespace :supplier do
    desc 'show migration target databases'
    task defined: :environment do
      raise "This task can be performed in non production." if Rails.env == 'production'
      puts DBSupplier::Migrator.databases.join("\n")
    end

    desc 'Migrate database from DDL files of unmanaged in the Rails App'
    task migrate: :environment  do
      raise "This task can be performed in non production." if Rails.env == 'production'
      DBSupplier::Migrator.migrate
    end

    namespace :migrate do
      desc 'Show DDL files of unmanaged in the Rails App'
      task sql: :environment do
        raise "This task can be performed in non production." if Rails.env == 'production'
        puts DBSupplier::Migrator.show_sqls
      end
    end
  end
end
