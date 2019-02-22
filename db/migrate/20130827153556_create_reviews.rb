class CreateReviews < ActiveRecord::Migration[4.2]
  def change
    create_table :reviews do |t|
      t.text :blurb
      t.integer :user_id
      t.integer :book_id
      t.integer :star

      t.timestamps
    end
  end
end
