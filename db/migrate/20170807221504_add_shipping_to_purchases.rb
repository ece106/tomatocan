class AddShippingToPurchases < ActiveRecord::Migration[4.2]
  def change
    add_column :purchases, :shipaddress, :string
    add_column :purchases, :fulfillstatus, :string
  end
end
