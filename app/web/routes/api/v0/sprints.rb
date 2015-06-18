module Commiker

  class Web < ::Sinatra::Base

    get '/api/v0/sprints/', auth: :user do
      json message: 'ping'
    end

    post '/api/v0/sprints/', auth: :user do
      ctx = UseCases::Sprints::Create::Base.perform(declared_params(:sprint))

      status 422 if ctx.status.unprocessable_entity?
      status 400 if ctx.status.bad_request?
      status 201 if ctx.status.created?

      json ctx.success? ? Serializers::Sprints::Show.new(ctx.sprint) : ctx.errors
    end

    get '/api/v0/sprints/:id', auth: :user do
      ctx = UseCases::Sprints::Show::Base.perform(declared_params)

      json Serializers::Sprints::Show.new(ctx.sprint)
    end

  end

end
