module Commiker
  module V0
    module UseCases
      module Stories
        module BulkCreate

          class Persist < UseCaseBase

            context_reader :pivotal_ids

            def perform
              tmp_pivotal_story = nil
              create_ctx = nil

              ctx.created_stories = []
              ctx.invalid_stories = []
              ctx.duplicated_stories = []

              pivotal_ids.each do |story_id|
                tmp_pivotal_story = grab_story_from_pivotal(story_id)

                if tmp_pivotal_story['kind'] == 'error'
                  ctx.invalid_stories << { pivotal_id: story_id }
                  next
                end

                story = ctx.sprint.stories.find_by(pivotal_id: tmp_pivotal_story['id'])

                if !story
                  story = \
                    Story.create!({
                      user: ctx.user,
                      pivotal_id: tmp_pivotal_story['id'],
                      description: tmp_pivotal_story['name']
                    })

                  ctx.created_stories << story

                  if !ctx.sprint.users.find_by(id: ctx.user.id)
                    ctx.sprint.users.push ctx.user
                  end

                  if !ctx.sprint.stories.find_by(pivotal_id: story.pivotal_id)
                    ctx.sprint.stories.push story
                  end

                  if !ctx.sprint.save
                    failure!(:unprocessable_entity, ctx.sprint.errors)
                    return
                  end
                else
                  ctx.duplicated_stories << {
                    pivotal_id: story.pivotal_id,
                    description: story.description
                  }
                end
              end

              ctx.status.ok!
            end

          private

            def grab_story_from_pivotal(story_id)
              cli = PivotalTrackerCli.new
              cli.find_story(story_id)
            end

          end

          class PivotalTrackerCli

            include HTTParty

            format :json
            base_uri 'https://www.pivotaltracker.com/services/v5'

            headers 'X-TrackerToken' => Configs['PIVOTAL_TOKEN']

            attr_reader :pivotal_token

            def find_story(story_id)
              PivotalTrackerCli.get("/stories/#{story_id}")
            end

          end

        end
      end
    end
  end
end
