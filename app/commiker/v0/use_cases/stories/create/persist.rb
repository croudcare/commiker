module Commiker
  module V0
    module UseCases
      module Stories
        module Create

          class Persist < UseCaseBase

            context_reader :story_attributes

            def perform
              story_attributes.delete(:sprint_id)

              ctx.story = \
                ctx.sprint.stories.create(story_attributes)

              if ctx.story.new_record?
                failure!(:unprocessable_entity, 'could not find an active sprint with the give sprint_id')
              else
                ctx.status.created!
              end
            end

          end

        end
      end
    end
  end
end
