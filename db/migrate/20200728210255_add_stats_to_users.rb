class AddStatsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :stats, :json, default: [], array:true
  end
end
