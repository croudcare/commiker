module Commiker

  class Web < ::Sinatra::Base

    get '/api/ping', auth: :user do
      authorize
    end

    get '/api/v0/stories/' do
      json message: 'ping'
    end

    patch '/api/v0/stories/:id/bump', auth: :user do
      json message: 'ping'
    end

  end

end
