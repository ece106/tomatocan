class CreateBannedUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :banned_users do |t|
      t.integer :user_id
      t.integer :host_id

      t.timestamps
    end

    # user_id column references id column of users table
    add_foreign_key :banned_users, :users, column: :user_id, primary_key: "id", on_delete: :cascade
    # host_id column references id column of users table
    add_foreign_key :banned_users, :users, column: :host_id, primary_key: "id", on_delete: :cascade    
  end
end
