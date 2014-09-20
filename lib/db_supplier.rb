require 'db_supplier/migrator'
require 'db_supplier/rails/railtie'

module DBSupplier
  VERSION = Gem.loaded_specs['db_supplier'].version.to_s
end
