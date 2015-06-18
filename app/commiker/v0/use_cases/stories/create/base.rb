module Commiker
  module V0
    module UseCases
      module Stories
        module Create

          class Base < UseCaseBase

            context_reader :story_attributes

            def perform

              if "#{story_attributes[:sprint_id]}".length == 0 ||
                  "#{story_attributes[:user_id]}".length == 0 ||
                    "#{story_attributes[:pivotal_id]}".length == 0 ||
                      "#{story_attributes[:description]}".length == 0
                failure!(:bad_request, 'missing required params sprint_id, user_id, pivotal_id or description')
              end

              context.story = Story.create(story_attributes)
            end

          end

        end
      end
    end
  end
end
