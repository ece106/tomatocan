class AddEmailToPurchases < ActiveRecord::Migration[5.2]
  def change
    add_column :purchases, :email, :string
  end
end
