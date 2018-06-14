class AddBookfilesToBooks < ActiveRecord::Migration[4.2]
  def change
    add_column :books, :bookmobi, :string
    add_column :books, :bookepub, :string
    add_column :books, :bookkobo, :string
  end
end
