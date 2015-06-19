module Commiker

  class Web < ::Sinatra::Base

    get '/api/ping', auth: :user do
      authorize
    end

    post '/api/v0/stories/bulk_create', auth: :user do
      ctx = UseCases::Stories::BulkCreate::Base.perform(declared_params)

      status 422 if ctx.status.unprocessable_entity?
      status 400 if ctx.status.bad_request?
      status 201 if ctx.status.created?

      json ctx.success? ? Serializers::Stories::BulkCreate.new(ctx) : ctx.errors
    end

    post '/api/v0/stories/:id/add_story_interaction', auth: :user do
      ctx = UseCases::Stories::AddStoryInteraction::Base.perform(declared_params(:story_interaction))

      status 422 if ctx.status.unprocessable_entity?
      status 400 if ctx.status.bad_request?
      status 201 if ctx.status.created?

      json ctx.success? ? Serializers::Stories::Index.new(ctx.story) : ctx.errors
    end

  end

end
