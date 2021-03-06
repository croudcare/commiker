module Commiker
  module V0
    module UseCases
      module Stories

        class FindOne < UseCaseBase

          def perform
            context.story = Story.find(context.id.to_i)
          end

        end

      end
    end
  end
end
