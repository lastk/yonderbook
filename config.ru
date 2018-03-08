# frozen_string_literal: true
dev = ENV['RACK_ENV'] == 'development'

if dev
  require 'logger'
  require 'dotenv/load'
  logger = Logger.new($stdout)
end

require 'rack/unreloader'
Unreloader = Rack::Unreloader.new(:subclasses=>%w'Roda Sequel::Model', :logger=>logger, :reload=>dev){App}
require_relative 'models'
Unreloader.require('app.rb'){'App'}

Rollbar.configure do |config|
  config.access_token = 'ee0a8b14155148c28004d3e9b7519abd'
end

run(dev ? Unreloader : App.freeze.app)
