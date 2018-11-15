class ChangeBookepubToMerchepub < ActiveRecord::Migration[5.2]
  def change
    rename_column :merchandises, :bookepub, :merchepub
  end
end
