class DropBannedUsers < ActiveRecord::Migration[5.2]
  def change
    drop_table :banned_users do |t|
      t.integer :user, null: false
      t.integer :host, null:false
      t.timestamps null: false
    end
  end
end
