class CreateMovies < ActiveRecord::Migration[5.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.text :about
      t.string :youtube1
      t.string :youtube2
      t.string :youtube3
      t.string :videodesc1
      t.string :videodesc2
      t.string :videodesc3
      t.string :moviepic
      t.string :genre
      t.float :price

      t.timestamps
    end
  end
end
