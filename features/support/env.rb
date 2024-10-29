require 'simplecov'
SimpleCov.start 'rails' do
  add_group 'Helpers', 'app/helpers'
  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  track_files 'app/helpers/*/.rb'  # Ensure helpers are tracked
end

require 'cucumber/rails'

require 'rack_session_access/capybara'

Capybara.save_path= "test_view"

ActionController::Base.allow_rescue = false

begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise 'You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it.'
end

Cucumber::Rails::Database.javascript_strategy = :truncation

Before do
  DatabaseCleaner.strategy = :transaction
  DatabaseCleaner.start
end

After do
  DatabaseCleaner.clean
end
