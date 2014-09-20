require 'db_supplier'
require 'active_record'
require 'pry'

DBSupplier::Migrator.configurations = {
  schema_repository: 'ryopeko/demo_schema',
  access_token: ENV['TOKEN'],
  schema_files: {
    external_database: ['DEMO/APPS/DEFAULT/latest.sql']
  }
}

ActiveRecord::Base.configurations = {
  'external_database' => {
    adapter: 'sqlite3',
    database: 'external_db_name.sqlite3'
  }
}

ActiveRecord::Base.establish_connection(:external_database)

binding.pry
