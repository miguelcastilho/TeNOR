# Set environment
ENV['RACK_ENV'] ||= 'development'

require 'sinatra'
require 'sinatra/config_file'
require 'yaml'
require "sinatra/activerecord"
require 'sinatra/gk_auth'

# Require the bundler gem and then call Bundler.require to load in all gems
# listed in Gemfile.
require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

require 'will_paginate/active_record'

require_relative 'models/init'
require_relative 'routes/init'
require_relative 'helpers/init'

configure do
	# Configure logging
	enable :logging
	log_file = File.new("#{settings.root}/log/#{settings.environment}.log", "a+")
	log_file.sync = true
	use Rack::CommonLogger, log_file
end

before do
	logger.level = Logger::DEBUG
end

class OrchestratorSlaEnforcement < Sinatra::Application
	register Sinatra::ConfigFile
	register Sinatra::ActiveRecordExtension
	# Load configurations
	config_file 'config/config.yml'
	set :database_file, "config/database.yml"
	#use Rack::CommonLogger, LogStashLogger.new(host: settings.logstash_host, port: settings.logstash_port)

	before do
		content_type 'application/json'
	end
end
