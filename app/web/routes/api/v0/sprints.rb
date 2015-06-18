module Commiker

  class Web < ::Sinatra::Base

    get '/api/v0/sprints/', auth: :user do
      ctx = UseCases::Sprints::Index::Base.perform(declared_params)

      json Serializers::Sprints::Index.new(ctx)
    end

    post '/api/v0/sprints/', auth: :user do
      ctx = UseCases::Sprints::Create::Base.perform(declared_params(:sprint))

      status 422 if ctx.status.unprocessable_entity?
      status 400 if ctx.status.bad_request?
      status 201 if ctx.status.created?

      json ctx.success? ? Serializers::Sprints::Show.new(ctx.sprint) : ctx.errors
    end

    post '/api/v0/sprints/:sprint_id/users/:user_id/stories', auth: :user do
      ctx = UseCases::Sprints::Users::Stories::Create::Base.perform(declared_params)

      status 422 if ctx.status.unprocessable_entity?
      status 400 if ctx.status.bad_request?
      status 201 if ctx.status.created?

      json ctx.success? ? Serializers::Stories::Index.new(ctx) : ctx.errors
    end

    get '/api/v0/sprints/:id', auth: :user do
      ctx = UseCases::Sprints::Show::Base.perform(declared_params)

      json Serializers::Sprints::Show.new(ctx.sprint)
    end

  end

end
