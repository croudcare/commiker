module Commiker
  module V0

    class Story < Base

      acts_as_paranoid

      default_scope { order('stories.created_at DESC') }

      belongs_to :user
      belongs_to :sprint
      has_many :story_interactions

      def completion_percentage
        story = \
          story_interactions
            .order('interacted_at DESC')
            .first

        return 0 if story.nil?

        story.completion_percentage
      end

    end

  end
end
