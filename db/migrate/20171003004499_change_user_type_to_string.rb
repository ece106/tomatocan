class ChangeUserTypeToString < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :author, :string
  end
end