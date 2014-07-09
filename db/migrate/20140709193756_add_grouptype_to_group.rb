class AddGrouptypeToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :grouptype, :integer
  end
end
