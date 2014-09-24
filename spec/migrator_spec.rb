require 'spec_helper.rb'
require 'db_supplier/migrator'

def migrate_class
  DBSupplier::Migrator.dup
end

describe DBSupplier::Migrator do
  describe ".client" do
    context "when access_token is not present" do
      it { expect { migrate_class.client }.to raise_error(RuntimeError) }
    end

    context "when access_token is present" do
      let (:set_access_token) {
        migrate_class.tap {|s|
          s.configurations = {
            access_token: 'access_token',
            schema_files: { foo: 'bar' }
          }
        }
      }

      it { expect(set_access_token.client).to be_a_kind_of(Octokit::Client) }
    end
  end

  describe ".databases" do
    context "when schema_files is not present" do
      it { expect(migrate_class.databases).to be_empty }
    end

    context "when schema_files is present" do
      let (:database_name) { :foo }
      let (:databases) { { database_name => 'bar' } }
      let (:set_databases) {
        migrate_class.tap {|s|
          s.configurations = {
            access_token: 'access_token',
            schema_files: databases
          }
        }
      }

      it { expect(set_databases.databases).to eq [database_name] }
    end
  end

  describe ".fetch_sql" do
    context "when schema_repository is not present" do
      it { expect { migrate_class.fetch_sql(:db_name) }.to raise_error(RuntimeError) }
    end

    context "when repository is not present" do
      let (:set_schema_files) {
        migrate_class.tap {|s|
          s.configurations = {
            access_token: 'access_token',
            schema_files: { foo: 'bar' }
          }
        }
      }

      it { expect { set_schema_files.fetch_sql(:foo) }.to raise_error(RuntimeError) }
    end

    context "when schema_repository and repository are present" do
      let (:db_name) { :foo }
      let (:set_all_args) {
        migrate_class.tap {|s|
          s.configurations = {
            schema_repository: 'repo_name',
            access_token: 'access_token',
            schema_files: { db_name => 'bar' }
          }
        }
      }

      allow_any_instance_of(Octokit::Client).to receive(:contents).and_return('sql')

      it { expect(set_all_args.fetch_sql(db_name)).to eq ['sql'] }
    end
  end
end
