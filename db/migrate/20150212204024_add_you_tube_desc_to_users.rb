class AddYouTubeDescToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :videodesc1, :string
    add_column :users, :videodesc2, :string
    add_column :users, :videodesc3, :string
  end
end
