module Commiker

  class Web < ::Sinatra::Base

    before '/me*' do
      redirect to('/') if current_session_user.blank?
    end

    get '/me' do
      erb :'me/index'
    end

    put '/me' do
      ctx = \
        UseCases::Users::CompleteRegistration::Base.perform declared_params(:user)

      status 422 if ctx.status.unprocessable_entity?

      if ctx.status.ok?
        redirect to('/')
      else
        erb :'me/signup'
      end
    end

    get '/me/signup' do
      if current_session_user.registration_complete
        redirect to('/')
      else
        erb :'me/signup'
      end
    end

  end

end
