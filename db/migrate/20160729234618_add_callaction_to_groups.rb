class AddCallactionToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :callaction, :text
  end
end
