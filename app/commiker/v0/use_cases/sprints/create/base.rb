module Commiker
  module V0
    module UseCases
      module Sprints
        module Create

          class Base < UseCaseBase

            depends ParseParams

            context_reader :sprint_attributes

            def perform
              # complete params
              sprint_attributes.merge!(starter_id: current_user.id)

              ctx.sprint = Sprint.create(sprint_attributes)
            end

          end

        end
      end
    end
  end
end
