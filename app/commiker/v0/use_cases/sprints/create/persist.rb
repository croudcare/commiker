module Commiker
  module V0
    module UseCases
      module Sprints
        module Create

          class Persist < UseCaseBase

            context_reader :sprint_attributes

            def perform
              # complete params
              sprint_attributes.merge!(starter_id: current_user.id)

              ctx.sprint = Sprint.create(sprint_attributes)

              ctx.status.created!
            end

          end

        end
      end
    end
  end
end
