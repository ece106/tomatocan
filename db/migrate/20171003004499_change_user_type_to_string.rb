class ChangeUserTypeToString < ActiveRecord::Migration[4.2]
  def change
    change_column :users, :author, :string
  end
end