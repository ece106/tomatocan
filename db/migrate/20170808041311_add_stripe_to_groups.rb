class AddStripeToGroups < ActiveRecord::Migration[4.2]
  def change
    add_column :groups, :stripeid, :string
    add_column :groups, :stripe_customer_token, :string
    add_column :groups, :stripesignup, :datetime
  end
end
