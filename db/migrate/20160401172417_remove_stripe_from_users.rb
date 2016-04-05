class RemoveStripeFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :stripe, :string
  end
end
