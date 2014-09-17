class RemoveTypeFromGroups < ActiveRecord::Migration
  def change
    remove_column :groups, :type, :string
  end
end
