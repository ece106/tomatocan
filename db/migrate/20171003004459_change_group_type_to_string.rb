class ChangeGroupTypeToString < ActiveRecord::Migration[5.0]
  def change
    change_column :groups, :grouptype, :string
  end
end