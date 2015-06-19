module Commiker
  module V0
    module UseCases
      module Stories
        module AddStoryInteraction

          class Base < UseCaseBase

            depends Stories::FindOne,
                    ParseParams

            context_reader :story,
                           :story_interaction_attributes

            def perform

            end

          end

        end
      end
    end
  end
end
