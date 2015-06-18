module Commiker
  module V0
    module UseCases
      module Sprints
        module Users
          module Stories
            module Create

              class Base < UseCaseBase

                depends Sprints::FindOne,
                        UseCases::Users::FindOne

                context_reader :sprint,
                               :user,
                               :story_attributes

                def perform
                  if !story_attributes.has_key?(:pivotal_ids)
                    failure(:bad_request, 'missing required param pivotal_ids')
                    return
                  end

                  if !sprint
                    failure(:bad_request, 'missing required param sprint_id')
                    return
                  end

                  if !user
                    failure(:bad_request, 'missing required param user_id')
                    return
                  end

                  tmp_pivotal_story = nil
                  ctx.stories = []

                  Story.transaction do
                    story_attributes[:pivotal_ids].each do |story_id|
                      tmp_pivotal_story = grab_story_from_pivotal(story_id)

                      if tmp_pivotal_story['kind'] == 'error'
                        failure(:bad_request, "unable to find story with id #{story_id}, stories not created")
                        raise ActiveRecord::Rollback
                      end

                      create_ctx = UseCases::Stories::Create::Base.perform \
                        story_attributes: {
                          sprint_id: sprint.id,
                          user_id: user.id,
                          pivotal_id: tmp_pivotal_story['id'],
                          description: tmp_pivotal_story['name']
                        }

                      ctx.stories << create_ctx.story
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
  end
end
