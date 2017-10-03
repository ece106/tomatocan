class ChangeGroupTypeToString < ActiveRecord::Migration
  def change
    change_column :groups, :grouptype, :string
  end
end