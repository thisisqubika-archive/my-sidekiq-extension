require 'my-sidekiq-extension'

class HelloWorld
  include Sidekiq::Worker

  def perform
    puts 'Hello World'
  end
end

class WhatTimeIsIt
  include Sidekiq::Worker

  def perform
    puts Time.now
  end
end
