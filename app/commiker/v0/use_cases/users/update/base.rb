module Commiker
  module V0
    module UseCases
      module Users
        module Update

          class Base < UseCaseBase

            depends ParseParams

            context_reader :current_session_user,
                           :user_attributes

            def perform
              unless current_session_user.update_attributes(user_attributes)
                failure!(:unprocessable_entity)
              end
            end

          end

        end
      end
    end
  end
end
