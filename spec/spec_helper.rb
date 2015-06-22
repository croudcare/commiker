$: <<  File.expand_path('../',File.dirname(__FILE__))

ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'bundler/setup'
require 'database_cleaner'
require 'webmock/rspec'
# WebMock.disable_net_connect!(allow_localhost: true)

Bundler.require :test

require 'boot'
require 'spec/helpers/use_case_helper'
require 'spec/helpers/request_helper'

module AppHelper

  def app
    Commiker::Web
  end

end

ActiveRecord::Base.logger = nil unless ENV['LOG'] == true

RSpec.configure do |config|

  config.include FactoryGirl::Syntax::Methods
  config.include Rack::Test::Methods

  config.order = 'random'
  config.include AppHelper
  config.include UseCaseHelper
  config.include RequestHelper

  config.before(:suite) do
    DatabaseCleaner[:active_record].strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner[:active_record].start
  end

  config.after(:each) do
    DatabaseCleaner[:active_record].clean
  end

end

FactoryGirl.definition_file_paths = %w{./spec/factories}
FactoryGirl.find_definitions
