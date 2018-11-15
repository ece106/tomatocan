class ChangeBookpdfToMerchpdf < ActiveRecord::Migration[5.2]
  def change
    rename_column :merchandises, :bookpdf, :merchpdf
  end
end
