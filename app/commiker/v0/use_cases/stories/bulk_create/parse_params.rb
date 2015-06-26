module Commiker
  module V0
    module UseCases
      module Stories
        module BulkCreate

          class ParseParams < UseCaseBase

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
            end

          end

        end
      end
    end
  end
end
