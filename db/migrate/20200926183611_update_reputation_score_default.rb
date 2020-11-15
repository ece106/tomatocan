class UpdateReputationScoreDefault < ActiveRecord::Migration[6.0]
  def change
    change_column_default(:users, :reputation_score, 0)
  end
end
