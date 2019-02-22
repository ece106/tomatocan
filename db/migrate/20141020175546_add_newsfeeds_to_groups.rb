class AddNewsfeedsToGroups < ActiveRecord::Migration[4.2]
  def change
    add_column :groups, :newsurl, :string
    add_column :groups, :twitter, :string
    add_column :groups, :facebook, :string
  end
end
