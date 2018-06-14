class AddPermalinkToGroups < ActiveRecord::Migration[4.2]
  def change
    add_column :groups, :permalink, :string
  end
end
