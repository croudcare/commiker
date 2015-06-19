module Commiker
  module V0
    module UseCases
      module Stories
        module AddStoryInteraction

          class ParseParams < UseCaseBase

            context_reader :story,
                           :story_interaction_attributes

            def perform
              if !story
                failure!(:not_found)
                return
              end

              if !story_interaction_attributes
                failure!(:bad_request, 'missing required param story_interaction')
                return
              end

              if "#{story_interaction_attributes['completion_percentage']}".length == 0
                failure!(:bad_request, 'missing required param completion')
                return
              end

              begin
                valid_value = \
                  Float(story_interaction_attributes['completion_percentage']).to_i

                if valid_value >= 0 && valid_value <= 100
                  story_interaction_attributes['completion_percentage'] = valid_value
                else
                  failure!(:unprocessable_entity, 'invalid value for completion, must be between 0 and 100')
                end
              rescue
                failure!(:unprocessable_entity, 'invalid value for completion')
                return
              end

            end

          end

        end
      end
    end
  end
end
