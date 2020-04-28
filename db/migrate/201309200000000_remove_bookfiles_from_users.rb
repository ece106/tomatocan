class RemoveBookfilesFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :bookmobi
    remove_column :users, :bookepub
    remove_column :users, :bookkobo
  end
end
