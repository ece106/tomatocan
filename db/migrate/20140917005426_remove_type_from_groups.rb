class RemoveTypeFromGroups < ActiveRecord::Migration[4.2]
  def change
    remove_column :groups, :type, :string
  end
end
