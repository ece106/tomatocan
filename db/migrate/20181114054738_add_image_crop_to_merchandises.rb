class AddImageCropToMerchandises < ActiveRecord::Migration[5.2]
  def change
    add_column :merchandises, :itempic_crop_x, :integer
    add_column :merchandises, :itempic_crop_y, :integer
    add_column :merchandises, :itempic_crop_w, :integer
    add_column :merchandises, :itempic_crop_h, :integer
  end
end
