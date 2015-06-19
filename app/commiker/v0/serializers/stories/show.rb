module Commiker
  module V0
    module Serializers
      module Stories

        class Show < Base

          attributes :id,
                     :sprint_id,
                     :user_id,
                     :pivotal_id,
                     :description

          has_one :user, serializer: Users::Show
          has_many :story_interactions, serializer: StoryInteractions::Show

        end

      end
    end
  end
end
