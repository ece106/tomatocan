class AddUploadersToMerchandises < ActiveRecord::Migration[5.2]
  def change
  	add_column :merchandises, :podcast, :string
  	add_column :merchandises, :video, :string
  	add_column :merchandises, :graphic, :string
  	add_column :merchandises, :bookepub, :string
  	add_column :merchandises, :bookmobi, :string
  	add_column :merchandises, :bookpdf, :string
  end
end
