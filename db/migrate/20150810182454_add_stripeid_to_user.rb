class AddStripeidToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :stripeid, :string
  end
end
