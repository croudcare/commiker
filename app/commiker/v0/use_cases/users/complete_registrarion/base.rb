module Commiker
  module V0
    module UseCases
      module Users
        module CompleteRegistration

          class Base < UseCaseBase

            depends Update::Base

            context_reader :current_session_user

            def perform
              current_session_user.update_column(:registration_complete, true)
            end

          end

        end
      end
    end
  end
end
