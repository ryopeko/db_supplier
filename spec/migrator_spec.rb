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

    context "when schema_files is not present" do
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
end
