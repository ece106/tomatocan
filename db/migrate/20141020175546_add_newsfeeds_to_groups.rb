class AddNewsfeedsToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :newsurl, :string
    add_column :groups, :twitter, :string
    add_column :groups, :facebook, :string
  end
end
