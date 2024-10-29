require 'simplecov'
SimpleCov.start 'rails' do
  add_group 'Helpers', 'app/helpers'
  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  track_files 'app/helpers/*/.rb'  # Ensure helpers are tracked
end

require 'spec_helper'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'factory_bot_rails'
require 'database_cleaner/active_record'

require 'rails-controller-testing'
Rails::Controller::Testing.install

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  ENV['RAILS_ENV'] ||= 'test'

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include FactoryBot::Syntax::Methods
end
