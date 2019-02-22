class RemoveStripeFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :stripe, :string
  end
end
