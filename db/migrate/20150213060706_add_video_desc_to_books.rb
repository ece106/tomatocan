class AddVideoDescToBooks < ActiveRecord::Migration[4.2]
  def change
    add_column :books, :bkvideodesc1, :string
    add_column :books, :bkvideodesc2, :string
  end
end
