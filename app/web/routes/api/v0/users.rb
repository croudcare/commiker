module Commiker

  class Web < ::Sinatra::Base

    get '/api/v0/users/', auth: :user do
      ctx = UseCases::Users::Index::Base.perform(declared_params)

      json ctx.success? ? Serializers::Users::Index.new(ctx) : ctx.errors
    end

  end

end
