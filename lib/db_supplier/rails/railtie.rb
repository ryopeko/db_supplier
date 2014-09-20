module DBSupplier
  module Rails
    class Railtie < ::Rails::Railtie
      rake_tasks do
        load 'db_supplier/rails/tasks.rake'
      end
    end
  end
end
