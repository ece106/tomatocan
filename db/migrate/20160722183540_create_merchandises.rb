class CreateMerchandises < ActiveRecord::Migration[4.2]
  def change
    create_table :merchandises do |t|
      t.string :name
      t.integer :user_id
      t.float :price
      t.text :desc
      t.string :itempic

      t.timestamps
    end
  end
end
