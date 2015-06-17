module Commiker
  module V0
    module UseCases
      module Story

        class FindOne < UseCaseBase

          def perform
            context.story = Story.find(context.id)
          end

        end

      end
    end
  end
end
