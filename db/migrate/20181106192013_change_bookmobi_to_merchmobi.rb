class ChangeBookmobiToMerchmobi < ActiveRecord::Migration[5.2]
  def change
    rename_column :merchandises, :bookmobi, :merchmobi
  end
end
