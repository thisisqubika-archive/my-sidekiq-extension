require_relative 'lib/my-sidekiq-extension/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'my-sidekiq-extension'
  s.version     = MySidekiqExtension::VERSION
  s.summary     = 'Sidekiq extension example'
  s.description = 'Use as a starting point for building your own sidekiq extensions'

  s.license     = 'MIT'

  s.authors     = ['Gianfranco Zas']
  s.email       = ['gian@moove-it.com']
  s.homepage    = 'https://github.com/moove-it/my-sidekiq-extension'

  s.files       = Dir['{lib}/**/*'] + %w[MIT-LICENSE README.md]
  s.test_files  = Dir[]

  s.add_dependency 'sidekiq', '~> 4'
end
