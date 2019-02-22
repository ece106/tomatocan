class RemoveVideodescFromBooks < ActiveRecord::Migration[4.2]
  def change
    remove_column :books, :videodesc1, :string
    remove_column :books, :videodesc2, :string
    remove_column :books, :videodesc3, :string
  end
end
