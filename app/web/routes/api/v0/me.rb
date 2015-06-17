module Commiker

  class Web < ::Sinatra::Base

    get '/api/v0/me/gems/bumped', auth: :user do
      ctx = UseCases::Me::GemPosts::Bumped::Base.perform declared_params

      json ctx.serialized
    end

  end

end
