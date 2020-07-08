class BlockedUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :BlockedUsers, :text, default: [], array:true
  end
end
