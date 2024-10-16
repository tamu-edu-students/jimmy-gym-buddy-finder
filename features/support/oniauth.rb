Before do
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:default] = OmniAuth::AuthHash.new({
    provider: 'google_oauth2',
    uid: '123456789',
    info: {
      email: 'test@example.com',
      name: 'Test User'
    },
    credentials: {
      token: 'mock_token',
      refresh_token: 'mock_refresh_token',
      expires_at: Time.now + 1.week
    }
  })
end

Before('@omniauth_fail') do
  OmniAuth.config.mock_auth[:default] = :invalid_credentials
  OmniAuth.config.logger = Logger.new(nil)
end

After('@omniauth_fail') do
  OmniAuth.config.logger = Logger.new(STDOUT)
end

After do
  OmniAuth.config.test_mode = false
end
