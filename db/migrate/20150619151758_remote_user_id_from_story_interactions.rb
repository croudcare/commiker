class RemoteUserIdFromStoryInteractions < ActiveRecord::Migration
  def change
    remove_column :story_interactions, :user_id
  end
end
