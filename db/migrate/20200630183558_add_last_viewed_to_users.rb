class AddLastViewedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :last_viewed, :integer
  end
end
