class RemoveItempicCropFromMerchandises < ActiveRecord::Migration[5.2]
  def change 
    remove_column :merchandises, :itempic_crop_x, :string
    remove_column :merchandises, :itempic_crop_y, :string
    remove_column :merchandises, :itempic_crop_w, :string
    remove_column :merchandises, :itempic_crop_h, :string
  end
end
