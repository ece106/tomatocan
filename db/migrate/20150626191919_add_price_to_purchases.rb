class AddPriceToPurchases < ActiveRecord::Migration[4.2]
  def change
    add_column :purchases, :pricesold, :float
  end
end
