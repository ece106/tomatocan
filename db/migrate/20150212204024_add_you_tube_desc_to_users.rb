class AddYouTubeDescToUsers < ActiveRecord::Migration
  def change
    add_column :users, :videodesc1, :string
    add_column :users, :videodesc2, :string
    add_column :users, :videodesc3, :string
  end
end
