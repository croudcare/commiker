module Commiker
  module V0
    module UseCases
      module Sprints
        module Create

          class Persist < UseCaseBase

            context_reader :sprint_attributes

            def perform
              # complete params
              sprint_attributes.merge!({
                starter_id: current_user.id,
                active: true
              })

              active_sprints = Sprint.where(active: true).count

              if active_sprints == 0
                ctx.sprint = Sprint.create(sprint_attributes)
                ctx.status.created!
              else
                failure!(:unprocessable_entity, 'there is already a sprint on track')
                ctx.start_bot = false
                return
              end
            end

          end

        end
      end
    end
  end
end
