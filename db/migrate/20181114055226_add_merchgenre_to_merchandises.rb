class AddMerchgenreToMerchandises < ActiveRecord::Migration[5.2]
  def change
    add_column :merchandises, :merchgenre, :string
  end
end
