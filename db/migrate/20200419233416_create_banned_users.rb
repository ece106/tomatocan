class CreateBannedUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :banned_users do |t|
      t.integer :user
      t.integer :host

      t.timestamps
    end

    add_foreign_key :banned_users, :users, column: :user, primary_key: "id"
    add_foreign_key :banned_users, :events, column: :host, primary_key: "user_id"
  end
end
