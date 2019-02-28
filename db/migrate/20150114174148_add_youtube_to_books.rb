class AddYoutubeToBooks < ActiveRecord::Migration[4.2]
  def change
    add_column :books, :youtube1, :text
    add_column :books, :youtube2, :text
  end
end
