module Commiker
  module V0
    module UseCases
      module Users

        class FindOne < UseCaseBase

          context_reader :id,
                         :user_id,
                         :slack_uid,
                         :user

          def perform
            if !user
              if slack_uid
                context.user = User.find_by(slack_uid: slack_uid)
              end

              if(user_id || id)
                context.user = User.find(id || user_id)
              end
            end
          end

        end

      end
    end
  end
end
