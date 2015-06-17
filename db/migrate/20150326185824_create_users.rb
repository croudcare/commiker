class CreateUsers < ActiveRecord::Migration

  def change
    create_table :users do |t|
      t.string :avatar_url
      t.string :email
      t.string :name
      t.string :slack_uid
      t.string :slack_handler
      t.boolean :registration_complete

      t.timestamps
    end
  end

end
