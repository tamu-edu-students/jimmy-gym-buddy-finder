Rails.logger.debug "Connecting to Redis at #{ENV['REDIS_URL']}"
$redis = Redis.new(
  url: ENV["REDIS_URL"],
  ssl: true,
  ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
)
