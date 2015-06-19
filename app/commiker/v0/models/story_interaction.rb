module Commiker
  module V0

    class StoryInteraction < Base

      default_scope { order('interacted_at DESC') }

      belongs_to :story

    end

  end
end
