module Commiker
  module V0
    module Serializers
      module Sprints

        class Show < Base

          root false

          attributes :id,
                     :obs,
                     :starter_id,
                     :started_at,
                     :ended_at,
                     :users,
                     :completion_percentage,
                     :active

          def users
            return [] if !object.users

            object.users.map do |user|
              Users::ShowWithStories.new(user, {
                stories: object.stories.where(user: user.id)
              })
            end
          end

        end

      end
    end
  end
end
