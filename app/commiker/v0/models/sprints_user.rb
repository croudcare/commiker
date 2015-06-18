module Commiker
  module V0

    class SprintsUser < Base

      belongs_to :user
      belongs_to :sprint

    end

  end
end
