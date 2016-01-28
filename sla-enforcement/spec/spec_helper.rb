# spec/spec_helper.rb
require 'rack/test'
require 'rspec'
ENV['RACK_ENV'] = 'test'

require_relative File.join('..', 'main')

RSpec.configure do |config|
  config.include Rack::Test::Methods

  def app
    OrchestratorSlaEnforcement
  end
end
