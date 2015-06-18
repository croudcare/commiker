class CreateSprints < ActiveRecord::Migration
  def change
    create_table :sprints do |t|
      t.integer :starter_id

      t.text :obs

      t.datetime :started_at
      t.datetime :ended_at
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
