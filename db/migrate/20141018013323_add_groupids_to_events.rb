class AddGroupidsToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :group1id, :integer
    add_column :events, :group2id, :integer
    add_column :events, :group3id, :integer
  end
end
