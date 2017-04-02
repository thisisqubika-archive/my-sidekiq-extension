module MySidekiqExtension
  class Runner
    def initialize(sidekiq_config)
      @sidekiq_config = sidekiq_config
      @shutdown_requested = false

      Sidekiq.logger.info { "Booting MySidekiqExtension. Options: #{my_options}" }
    end

    def on_startup
      save_my_options

      run
    end

    def on_shutdown
      Sidekiq.logger.debug { 'Received shutdown request' }

      @shutdown_requested = true
    end

    private
    def job_classes
      Array(my_options['class'])
    end

    def my_options
      sidekiq_options[:'my-sidekiq-extension']
    end

    def run
      interval = my_options['interval_sec']

      Thread.new do
        Sidekiq.logger.info { 'MySidekiqExtension thread has initiated' }

        loop do
          sleep interval
          break if @shutdown_requested

          job_classes.each do |job_class|
            Sidekiq::Client.push('class' => job_class, 'args' => [])
          end

          update_stats

          break if @shutdown_requested
        end

        Sidekiq.logger.info { 'MySidekiqExtension thread has finished' }
      end
    end

    def sidekiq_options
      @sidekiq_config.options
    end

    def save_my_options
      Sidekiq.redis do |r|
        r.set('my-sidekiq-extension:options', JSON.generate(my_options))
      end
    end

    def update_stats
      Sidekiq.redis do |r|
        r.multi do
          update_timestamps(r)
          update_counts(r)
        end
      end
    end

    def update_counts(r)
      job_classes.each do |job_class|
        r.hincrby('my-sidekiq-extension:counters', job_class, 1)
      end
    end

    def update_timestamps(r)
      now = Time.now.to_i

      timestamps = job_classes.map { |job_class| [job_class, now] }.flatten

      r.hmset('my-sidekiq-extension:timestamps', *timestamps)
    end
  end
end
