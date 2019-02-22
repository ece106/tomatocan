class AddAuthorcutToPurchases < ActiveRecord::Migration[4.2]
  def change
    add_column :purchases, :authorcut, :decimal, precision: 8, scale: 2
  end
end
