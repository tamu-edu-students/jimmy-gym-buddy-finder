Rails.application.config.middleware.use OmniAuth::Builder do
  # Retrieve the Google credentials from Rails credentials
  google_credentials = Rails.application.credentials.google

  # Configure the Google OAuth provider with the client_id and client_secret
  provider :google_oauth2, google_credentials[:client_id], google_credentials[:client_secret], {
      scope: "email, profile", # This grants access to the user's email and profile information.
      prompt: "select_account", # This allows users to choose the account they want to log in with.
      image_aspect_ratio: "square", # Ensures the profile picture is a square.
      image_size: 50 # Sets the profile picture size to 50x50 pixels.
      redirect_uri: "#{ENV['APP_URL']}/auth/google_oauth2/callback"
    }
end

OmniAuth.config.failure_raise_out_environments = []
OmniAuth.config.on_failure = Proc.new do |env|
  Rails.logger.debug "OmniAuth Failure Endpoint: #{env['omniauth.error.type']}, #{env['omniauth.error']}"
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
end
