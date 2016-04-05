class AddAuthorcutToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :authorcut, :decimal, precision: 8, scale: 2
  end
end
