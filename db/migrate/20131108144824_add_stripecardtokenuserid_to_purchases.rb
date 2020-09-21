class AddStripecardtokenuseridToPurchases < ActiveRecord::Migration[4.2]
  def change
    add_column :purchases, :stripe_card_token, :string
    add_column :purchases, :user_id, :integer
  end
end
