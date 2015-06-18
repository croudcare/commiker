module Commiker
  module V0

    class Sprint < Base

      belongs_to :starter, primary_key: 'starter_id'
      has_many :stories

      has_many :users, through: :sprints_users
      has_many :sprints_users

    end

  end
end
