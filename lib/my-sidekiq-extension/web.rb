require 'sidekiq/web'

module MySidekiqExtension
  module Web
    def self.registered(app)
      app.get('/my-extension') do
        @my_stats = Web.get_stats

        erb Web.view(:index)
      end
    end

    def self.view(view)
      full_path = Web.view_full_path(view)

      File.read(full_path)
    end

    def self.view_full_path(view)
      File.join(__dir__, 'web', 'views', "#{view}.erb")
    end

    def self.get_stats
      counters = nil
      timestamps = nil

      Sidekiq.redis do |r|
        r.multi do
          counters = r.hgetall('my-sidekiq-extension:counters')
          timestamps = r.hgetall('my-sidekiq-extension:timestamps')
        end
      end

      {
        counters: counters.value(),
        timestamps: timestamps.value()
      }
    end
  end
end

Sidekiq::Web.register(MySidekiqExtension::Web)
Sidekiq::Web.tabs['MySidekiqExtension'] = 'my-extension'
Sidekiq::Web.locales << File.join(__dir__, 'web/locales')
