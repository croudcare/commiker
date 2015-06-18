class AddImage32ToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar_32_url, :string
  end
end
