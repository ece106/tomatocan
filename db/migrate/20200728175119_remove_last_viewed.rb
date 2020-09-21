class RemoveLastViewed < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :last_viewed, :integer
  end
end
