require 'my-sidekiq-extension/web'

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

run Sidekiq::Web
