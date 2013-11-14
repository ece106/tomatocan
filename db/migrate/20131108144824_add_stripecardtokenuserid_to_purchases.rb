class AddStripecardtokenuseridToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :stripe_card_token, :string
    add_column :purchases, :user_id, :integer
  end
end
