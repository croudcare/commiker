module Commiker
  module V0

    class StoryInteraction < Base

      acts_as_paranoid

      default_scope { order('interacted_at DESC') }

      belongs_to :story

    end

  end
end
