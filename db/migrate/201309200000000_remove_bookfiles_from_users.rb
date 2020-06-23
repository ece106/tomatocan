class RemoveBookfilesFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :bookmobi, :string
    remove_column :users, :bookepub, :string
    remove_column :users, :bookkobo, :string
  end
end
