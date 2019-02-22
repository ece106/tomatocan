class ChangeMerchgenreToButtontype < ActiveRecord::Migration[5.2]
  def change
    rename_column :merchandises, :merchgenre, :buttontype
  end
end
