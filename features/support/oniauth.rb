OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
  provider: 'google_oauth2',
  uid: '12345',
  info: {
    email: 'user@example.com',
    name: 'John Doe'
  }
)