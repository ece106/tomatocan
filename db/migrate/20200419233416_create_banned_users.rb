class CreateBannedUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :banned_users do |t|
      # user id of banned user
      t.integer :user
      # id of event they're banned from
      t.integer :host

      t.timestamps
    end

    # user column references id column of users table
    add_foreign_key :banned_users, :users, column: :user, primary_key: "id"
    # host column references id column of events table
    add_foreign_key :banned_users, :events, column: :host, primary_key: "id"
  end
end
