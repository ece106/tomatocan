class AddBookfilesToBooks < ActiveRecord::Migration
  def change
    add_column :books, :bookmobi, :string
    add_column :books, :bookepub, :string
    add_column :books, :bookkobo, :string
  end
end
