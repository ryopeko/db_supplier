# DBSupplier
[![Build Status](https://travis-ci.org/ryopeko/db_supplier.svg?branch=master)](https://travis-ci.org/ryopeko/db_supplier)

Migration tool from external database's DDL.
Fetch sql from GitHub repository and migrate local database.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'db_supplier'
```

And then execute:

    $ bundle

## Usage

Add gem to your Gemfile then defined some 'rake tasks'.

    $ rake -T
    rake db:supplier:defined     # show migration target databases
    rake db:supplier:migrate     # Migrate database from DDL files of unmanaged in the Rails App
    rake db:supplier:migrate:sql # Show DDL files of unmanaged in the Rails App

### Configurations
Add your Rails Application's config/environments/*.rb

example: RAILS_ENV=development

config/environments/development.rb
```ruby
Rails.application.configure do
  DBSupplier::Migrator.configurations = {
    schema_repository: 'username/reponame',
    access_token: 'your github access token',
    schema_files: {
      databasename: ['path/to/ddl.sql']
    }
  }
end
```

#### params
schema_repository: DDL Repository

access_token: Your github access token

schema_files: Some pair of  database name and ddl file(s)


## Contributing

1. Fork it ( https://github.com/ryopeko/db_supplier/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
