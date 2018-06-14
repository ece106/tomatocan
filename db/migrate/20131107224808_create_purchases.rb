class CreatePurchases < ActiveRecord::Migration[4.2]
  def change
    create_table :purchases do |t|
      t.integer :author_id
      t.integer :book_id
      t.string :stripe_customer_token
      t.integer :plan_id

      t.timestamps
    end
  end
end
