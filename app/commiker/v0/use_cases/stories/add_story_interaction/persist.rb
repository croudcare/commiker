module Commiker
  module V0
    module UseCases
      module Stories
        module AddStoryInteraction

          class Persist < UseCaseBase

            context_reader :story,
                           :story_interaction_attributes

            def perform
              story_interaction_attributes.merge!({
                interacted_at: Time.now
              })

              if story.story_interactions.create(story_interaction_attributes)
                ctx.sprint = story.sprint
              end
            end

          end

        end
      end
    end
  end
end
