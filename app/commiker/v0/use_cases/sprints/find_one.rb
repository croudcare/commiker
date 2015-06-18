module Commiker
  module V0
    module UseCases
      module Sprints

        class FindOne < UseCaseBase

          def perform
            context.sprint = Sprint.find(context.id)
          end

        end

      end
    end
  end
end
