ENV['RACK_ENV'] = 'test'

require 'dotenv/load'
require 'minitest/autorun'
require 'rack/test'

require_relative 'spec_helper'
require_relative '../app'

include Rack::Test::Methods

def app
  App
end

describe App do
  it 'responds to root' do
    get '/'
    assert last_response.ok?
    assert_includes last_response.body, 'Bookwyrm'
  end
  it 'responds to root' do
    get '/about'
    assert last_response.ok?
    assert_includes last_response.body, 'About'
  end
end
