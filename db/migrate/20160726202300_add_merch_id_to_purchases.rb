class AddMerchIdToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :merchandise_id, :integer
  end
end
