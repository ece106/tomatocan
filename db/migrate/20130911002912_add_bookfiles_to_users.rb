class AddBookfilesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bookmobi, :string
    add_column :users, :bookepub, :string
    add_column :users, :bookkobo, :string
  end
end
