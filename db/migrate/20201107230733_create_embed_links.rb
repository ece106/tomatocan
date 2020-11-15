class CreateEmbedLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :embed_links do |t|
      t.string :border
      t.string :border_color
      t.string :border_size
      t.string :size
      t.string :location
      t.string :special_position

      t.timestamps
    end
  end
end
