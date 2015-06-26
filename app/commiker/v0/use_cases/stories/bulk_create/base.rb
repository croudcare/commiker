module Commiker
  module V0
    module UseCases
      module Stories
        module BulkCreate

          class Base < UseCaseBase

            depends ParseParams,
                    Persist,
                    Sprints::CommunicatePusher::Base

          end

        end
      end
    end
  end
end
