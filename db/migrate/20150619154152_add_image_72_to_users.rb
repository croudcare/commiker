class AddImage72ToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar_72_url, :string
  end
end
