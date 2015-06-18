module Commiker
  module V0

    class Story < Base

      belongs_to :user
      belongs_to :sprint
      has_many :story_interactions

    end

  end
end
