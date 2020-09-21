class AddTokenToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :stripe_customer_token, :string
    add_column :users, :stripe, :string
  end
end
