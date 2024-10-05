require 'simplecov'
SimpleCov.start 'rails' do
  add_group 'Helpers', 'app/helpers'
  track_files 'app/helpers/*/.rb'  # Ensure helpers are tracked
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
