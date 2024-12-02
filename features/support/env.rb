require 'simplecov'
SimpleCov.start 'rails' do
  add_group 'Helpers', 'app/helpers'
  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  track_files 'app/helpers/*/.rb'  # Ensure helpers are tracked
end

require 'cucumber/rails'

require 'rack_session_access/capybara'
require 'capybara/cuprite' # Require Cuprite

require 'selenium-webdriver'

Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless') # Uncomment for headless mode
  options.add_argument('--disable-gpu') # Disable GPU acceleration
  options.add_argument('--no-sandbox') # Disable sandboxing for Docker environments

  # Optionally, set the path to ChromeDriver if it's not in your PATH
  # options.driver_path = "/path/to/chromedriver"

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.javascript_driver = :chrome

World(Rack::Test::Methods)

Capybara.default_max_wait_time = 5 # Adjust as needed for your app

# Register Cuprite as the JavaScript driver
Capybara.register_driver :cuprite do |app|
  Capybara::Cuprite::Driver.new(app, headless: true)
end

Capybara.javascript_driver = :cuprite # Set Cuprite as the JavaScript drive

Capybara.save_path= "test_view"

ActionController::Base.allow_rescue = false

begin
  DatabaseCleaner.strategy = :truncation
rescue NameError
  raise 'You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it.'
end

Cucumber::Rails::Database.javascript_strategy = :truncation

Before do
  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.start
end

After do
  DatabaseCleaner.clean
end
