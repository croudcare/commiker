class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.integer :pivotal_id
      t.integer :sprint_id
      t.integer :user_id

      t.text :description

      t.datetime :deleted_at

      t.timestamps
    end
  end
end
