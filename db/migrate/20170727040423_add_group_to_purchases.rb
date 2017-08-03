class AddGroupToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :group_id, :integer
    add_column :purchases, :groupcut, :decimal, precision: 8, scale: 2
  end
end
