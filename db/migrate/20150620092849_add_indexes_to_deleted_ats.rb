class AddIndexesToDeletedAts < ActiveRecord::Migration
  def change
    add_index :sprints, :deleted_at
    add_index :stories, :deleted_at
    add_index :story_interactions, :deleted_at
  end
end
