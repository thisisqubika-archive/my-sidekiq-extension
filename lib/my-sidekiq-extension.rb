require 'sidekiq'
require 'my-sidekiq-extension/runner'

Sidekiq.configure_server do |config|
  runner = MySidekiqExtension::Runner.new(config)

  config.on(:startup) do
    Sidekiq.logger.debug { 'On startup' }

    runner.on_startup
  end

  config.on(:heartbeat) do
    Sidekiq.logger.debug { 'On heartbeat' }
  end

  config.on(:quiet) do
    Sidekiq.logger.debug { 'On quiet' }
  end

  config.on(:shutdown) do
    Sidekiq.logger.debug { 'On shutdown' }

    runner.on_shutdown
  end
end
