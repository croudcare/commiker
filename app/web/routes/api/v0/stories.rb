module Commiker

  class Web < ::Sinatra::Base

    get '/ping' do
      json true
    end

    post '/api/v0/stories', auth: :user do
      ctx = UseCases::Stories::Create::Base.perform(declared_params(:story))

      status 422 if ctx.status.unprocessable_entity?
      status 400 if ctx.status.bad_request?
      status 201 if ctx.status.created?

      json ctx.success? ? Serializers::Stories::Show.new(ctx.story) : ctx.errors
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

      json ctx.success? ? Serializers::Stories::Show.new(ctx.story) : ctx.errors
    end

    delete '/api/v0/stories/:id', auth: :user do
      ctx = UseCases::Stories::Delete::Base.perform(declared_params)

      status 422 if ctx.status.unprocessable_entity?
      status 202 if ctx.status.accepted?
    end

  end

end
