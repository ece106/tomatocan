class AddGrouptypeToGroup < ActiveRecord::Migration[4.2]
  def change
    add_column :groups, :grouptype, :integer
  end
end
