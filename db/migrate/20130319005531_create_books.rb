class CreateBooks < ActiveRecord::Migration[4.2]
  def change
    create_table :books do |t|
      t.string :title
      t.text :blurb
      t.date :releasedate
      t.integer :author_id
      t.string :genre
      t.string :fiftychar
      t.float :price
      t.string :bookpdf
      t.string :coverpic
      t.string :coverpicurl

      t.timestamps
    end
  end
end
