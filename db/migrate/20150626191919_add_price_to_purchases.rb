class AddPriceToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :pricesold, :float
  end
end
