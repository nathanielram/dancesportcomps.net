ErrorappNotifier.configure do|config|
  config.api_key = ENV["ERRORAPP_API_KEY"] || Rails.application.secrets.ERRORAPP_API_KEY
end


