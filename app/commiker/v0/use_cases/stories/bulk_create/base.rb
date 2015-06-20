module Commiker
  module V0
    module UseCases
      module Stories
        module BulkCreate

          class Base < UseCaseBase

            context_reader :sprint_id,
                           :user_slack_uid,
                           :pivotal_ids

            def perform
              if !pivotal_ids || (pivotal_ids && !pivotal_ids.is_a?(Array))
                failure!(:bad_request, 'missing required param array of pivotal_ids')
                return
              end

              if !sprint_id
                failure!(:bad_request, 'missing required param sprint_id')
                return
              else
                ctx.sprint = Sprint.find(sprint_id)

                if ctx.sprint.blank?
                  failure!(:unprocessable_entity, 'invalid sprint_id, could not find sprint')
                  return
                end
              end

              if !user_slack_uid
                failure!(:bad_request, 'missing required param user_slack_uid')
                return
              else
                ctx.user = User.find_by(slack_uid: user_slack_uid)

                if ctx.user.blank?
                  failure!(:unprocessable_entity, 'invalid user_slack_uid, could not find user')
                  return
                end
              end

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
