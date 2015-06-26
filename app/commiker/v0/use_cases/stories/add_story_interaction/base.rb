module Commiker
  module V0
    module UseCases
      module Stories
        module AddStoryInteraction

          class Base < UseCaseBase

            depends Stories::FindOne,
                    ParseParams,
                    Persist,
                    Sprints::CommunicatePusher::Base

          end

        end
      end
    end
  end
end
