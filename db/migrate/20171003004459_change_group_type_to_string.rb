class ChangeGroupTypeToString < ActiveRecord::Migration[4.2]
  def change
    change_column :groups, :grouptype, :string
  end
end