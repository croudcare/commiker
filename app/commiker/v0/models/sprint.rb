module Commiker
  module V0

    class Sprint < Base

      acts_as_paranoid

      default_scope { order('sprints.created_at DESC') }

      belongs_to :starter, primary_key: 'starter_id'
      has_many :stories

      has_many :users, through: :sprints_users
      has_many :sprints_users

      def completion_percentage
        total = (stories.count * 100)

        return 0 if (total == 0)

        completion_sum = stories.map(&:completion_percentage).sum

        (completion_sum * 100 / total)
      end

    end

  end
end
