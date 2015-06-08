Airbrake.configure do |config|
  config.api_key = ENV["AIRBRAKE_API_KEY"] || Rails.application.secrets.AIRBRAKE_API_KEY
end
