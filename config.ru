$:.unshift(File.dirname(__FILE__))

require 'rack/protection'
require 'boot'

use Rack::Session::Cookie, :key => 'rack.session',
                           :secret => Configs['SESSION_SECRET']

use Rack::Jwt::Auth::Authenticate, {
  only: ['/api/*'],
  secret: Configs['AUTHENTICATION_SECRET']
}

use OmniAuth::Builder do
  provider :slack, Configs['SLACK_CLIENT_ID'], Configs['SLACK_CLIENT_SECRET'], scope: 'identify', team: Configs['SLACK_TEAM_ID']
end

OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}

use Rack::MethodOverride
use Rack::Protection::EscapedParams

run Commiker::Web


