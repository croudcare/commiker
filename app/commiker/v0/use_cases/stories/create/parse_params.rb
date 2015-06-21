module Commiker
  module V0
    module UseCases
      module Stories
        module Create

          class ParseParams < UseCaseBase

            context_reader :story_attributes

            def perform
              if story_attributes.nil?
                failure!(:bad_request, 'missing required params for story')
                return
              end

              if "#{story_attributes['sprint_id']}".length == 0
                failure!(:bad_request, 'missing required param sprint_id')
                return
              else
                ctx.sprint = \
                  Sprint
                    .where(active: true, id: story_attributes['sprint_id'])
                    .first

                if ctx.sprint.nil?
                  failure!(:unprocessable_entity, 'could not find an active sprint with the give sprint_id')
                  return
                else
                  if ctx.sprint.users.where(id: current_user.id).count == 0
                    failure!(:unprocessable_entity, 'that user_id is not part of the sprint')
                  end
                end
              end

              if "#{story_attributes['pivotal_id']}".length == 0
                failure!(:bad_request, 'missing required param pivotal_id')
                return
              else
                begin
                  story_attributes['pivotal_id'] = Float(story_attributes['pivotal_id']).to_i
                rescue
                  failure!(:unprocessable_entity, 'invalid pivotal id, needs to be a number')
                end
              end

              if "#{story_attributes['description']}".length == 0
                failure!(:bad_request, 'missing required param description')
                return
              end
            end

          end

        end
      end
    end
  end
end
