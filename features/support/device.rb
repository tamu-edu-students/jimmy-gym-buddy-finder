# features/support/devise.rb
require 'devise'
require 'warden'

# Include Warden test helpers for Cucumber
World Warden::Test::Helpers
Warden.test_mode!

After do
  Warden.test_reset!
end
