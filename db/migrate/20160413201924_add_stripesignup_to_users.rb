class AddStripesignupToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stripesignup, :datetime
  end
end
