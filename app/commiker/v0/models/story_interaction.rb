module Commiker
  module V0

    class StoryInteraction < Base

      belongs_to :story
      belongs_to :sprint

    end

  end
end
