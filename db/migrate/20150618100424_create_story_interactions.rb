class CreateStoryInteractions < ActiveRecord::Migration
  def change
    create_table :story_interactions do |t|
      t.integer :story_id
      t.integer :user_id

      t.text :obs
      t.string :hashtags, array: true, default: []
      t.integer :completion_percentage

      t.datetime :interacted_at
      t.datetime :deleted_at

      t.timestamps
    end

  end
end
