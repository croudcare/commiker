require 'omniauth'
require 'omniauth-slack'

module Commiker

  class Web < ::Sinatra::Base

    set(:auth) do |*roles|
      condition { authorize } if roles.include? :user
    end

  end

end

require_relative './api/v0/me'
require_relative './api/v0/users'
require_relative './api/v0/stories'
require_relative './api/v0/sprints'
require_relative './me'

module Commiker

  class Web < ::Sinatra::Base

    get '/login' do
      unescaped_params = CGI::parse(request.query_string)
      origin = unescaped_params['origin'][0]

      if current_session_user.blank?
        redirect to("/auth/slack?origin=#{origin}")
      else
        redirect to('/')
      end
    end

    get '/logout' do
      session[:user_id] = nil

    	redirect to('/')
    end

    get '/auth/failure' do
      params[:message]
      redirect to('/')
    end

    get '/auth/slack/callback' do
      if current_session_user.blank?
        origin = CGI::parse(request.query_string)['origin'][0] || '/'

        ctx = UseCases::Users::FindOrCreate::Base
          .perform(slack_uid: env['omniauth.auth']['uid'], omniauth_data: env['omniauth.auth'])

        session[:user_id] = ctx.user.id

        if ctx.user.registration_complete
          redirect to(origin)
        else
          redirect to('/me/signup')
        end
  		end

      redirect to('/')
    end

    get '/*' do
      if request.path.split('/')[1] == 'api'
        halt 404
      else
        erb :home
      end
    end

  end

end
