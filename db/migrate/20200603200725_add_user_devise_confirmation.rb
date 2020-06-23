class AddUserDeviseConfirmation < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string

    say "CONFIRMING ALREADY REGISTERED USERS"
    User.find_each do |user|
      user.confirmation_sent_at = Time.now - 10.minutes
      user.confirmed_at = Time.now
      user.save
    end
  end
end
