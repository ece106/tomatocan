class AddPaidToPurchases < ActiveRecord::Migration[4.2]
  def change
    add_column :purchases, :paid, :date
  end
end
