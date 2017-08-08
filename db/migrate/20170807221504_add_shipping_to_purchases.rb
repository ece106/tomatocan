class AddShippingToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :shipaddress, :string
    add_column :purchases, :fulfillstatus, :string
  end
end
