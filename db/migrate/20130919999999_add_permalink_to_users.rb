class AddPermalinkToUsers < ActiveRecord::Migration
  def change
    add_column :users, :permalink, :string
    add_index :users, :permalink, :unique => true
  end
end
