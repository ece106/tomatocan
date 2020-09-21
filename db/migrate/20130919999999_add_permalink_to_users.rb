class AddPermalinkToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :permalink, :string
    add_index :users, :permalink, :unique => true
  end
end
