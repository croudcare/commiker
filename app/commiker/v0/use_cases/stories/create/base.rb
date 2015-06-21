module Commiker
  module V0
    module UseCases
      module Stories
        module Create

          class Base < UseCaseBase

            depends ParseParams,
                    Persist

          end

        end
      end
    end
  end
end
