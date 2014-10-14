class AddPermalinkToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :permalink, :string
  end
end
