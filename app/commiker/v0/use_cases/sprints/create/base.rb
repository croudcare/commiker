module Commiker
  module V0
    module UseCases
      module Sprints
        module Create

          class Base < UseCaseBase

            depends ParseParams,
                    Persist,
                    StartBOT

          end

        end
      end
    end
  end
end
