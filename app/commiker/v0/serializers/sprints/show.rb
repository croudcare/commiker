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
            tmp_user_stories = []

            object.users.map do |user|
              tmp_user_stories = object.stories.where(user: user.id)

              Users::ShowWithStories.new(user, {
                stories: tmp_user_stories
              })
            end
          end

        end

      end
    end
  end
end
