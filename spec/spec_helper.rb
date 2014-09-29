require 'rspec/mocks/standalone'
require 'simplecov'
require 'tapp'

require 'coveralls'
Coveralls.wear!

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter
]

SimpleCov.start do
  add_filter 'spec'
end

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  if config.files_to_run.one?
    config.full_backtrace = true
    config.default_formatter = 'doc'
  end

  config.order = :random
  Kernel.srand config.seed
end
