class AddReputationScoreColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :reputation_score, :integer, default: 0
  end
end
