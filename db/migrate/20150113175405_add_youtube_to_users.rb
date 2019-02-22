class AddYoutubeToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :youtube1, :text
    add_column :users, :youtube2, :text
    add_column :users, :youtube3, :text
  end
end
