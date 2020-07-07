class BlockedBy < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :blockedBy, :text, default: [], array:true
  end
end
