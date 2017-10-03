class ChangeUserTypeToString < ActiveRecord::Migration
  def change
    change_column :users, :author, :string
  end
end