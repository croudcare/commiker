class CreateSprintsUsers < ActiveRecord::Migration
  def change
    create_table :sprints_users do |t|
      t.integer :sprint_id
      t.integer :user_id

      t.timestamps
    end

  end
end
