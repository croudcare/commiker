module Commiker
  module V0
    module UseCases
      module Sprints

        class FindOne < UseCaseBase

          context_reader :sprint_id,
                         :id

          def perform
            context.sprint = Sprint.find(sprint_id || id)
          end

        end

      end
    end
  end
end
