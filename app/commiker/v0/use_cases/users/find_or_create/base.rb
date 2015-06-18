module Commiker
  module V0
    module UseCases
      module Users
        module FindOrCreate

          class Base < UseCaseBase

            context_reader :slack_uid,
                           :omniauth_data

            def perform
              context.user = \
                Users::FindOne.perform(slack_uid: slack_uid).user

              context.user = persist_user if !context.user
            end

            def persist_user
              user = User.new({
                name: omniauth_data['info']['name'],
                email: omniauth_data['info']['email'],
                avatar_url: omniauth_data['info']['image'],
                avatar_32_url: (omniauth_data['extra']['user_info']['user']['profile']['image_32'] rescue ''),
                slack_uid: slack_uid,
                slack_handler: omniauth_data['info']['nickname'],
                registration_complete: true
              })

              if user.save
                user
              end
            end

          end

        end
      end
    end
  end
end
