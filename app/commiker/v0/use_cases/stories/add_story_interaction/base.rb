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
              story_interaction_attributes.merge!({
                interacted_at: Time.now
              })

              story.story_interactions.create(story_interaction_attributes)
            end

          end

        end
      end
    end
  end
end
