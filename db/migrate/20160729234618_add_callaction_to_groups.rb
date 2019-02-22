class AddCallactionToGroups < ActiveRecord::Migration[4.2]
  def change
    add_column :groups, :callaction, :text
  end
end
