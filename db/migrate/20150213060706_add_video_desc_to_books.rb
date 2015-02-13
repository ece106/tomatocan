class AddVideoDescToBooks < ActiveRecord::Migration
  def change
    add_column :books, :bkvideodesc1, :string
    add_column :books, :bkvideodesc2, :string
  end
end
