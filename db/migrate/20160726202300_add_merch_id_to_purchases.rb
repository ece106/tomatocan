class AddMerchIdToPurchases < ActiveRecord::Migration[4.2]
  def change
    add_column :purchases, :merchandise_id, :integer
  end
end
