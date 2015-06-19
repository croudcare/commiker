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
              if !pivotal_ids
                failure!(:bad_request, 'missing required param array of pivotal_ids')
                return
              end

              if !sprint_id
                failure!(:bad_request, 'missing required param sprint_id')
                return
              end

              if !user_slack_uid
                failure!(:bad_request, 'missing required param user_slack_uid')
                return
              else
                ctx.user = User.find_by(slack_uid: user_slack_uid)
              end

              tmp_pivotal_story = nil
              create_ctx = nil
              ctx.stories = []

              Story.transaction do

                pivotal_ids.each do |story_id|
                  tmp_pivotal_story = grab_story_from_pivotal(story_id)

                  if tmp_pivotal_story['kind'] == 'error'
                    failure!(:unprocessable_entity, "unable to find story with id #{story_id}, stories not created")
                    raise ActiveRecord::Rollback
                  end

                  create_ctx = UseCases::Stories::Create::Base.perform \
                    story_attributes: {
                      sprint_id: sprint_id,
                      user_id: ctx.user.id,
                      pivotal_id: tmp_pivotal_story['id'],
                      description: tmp_pivotal_story['name']
                    }

                  if create_ctx.success?
                    ctx.stories << create_ctx.story
                  else
                    raise ActiveRecord::Rollback
                  end
                end

                ctx.status.created!
              end
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
