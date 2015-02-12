class AddYouTubeDescToBooks < ActiveRecord::Migration
  def change
    add_column :books, :videodesc1, :string
    add_column :books, :videodesc2, :string
    add_column :books, :videodesc3, :string
  end
end
