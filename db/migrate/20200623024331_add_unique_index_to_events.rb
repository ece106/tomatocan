class AddUniqueIndexToEvents < ActiveRecord::Migration[6.0]
  def change
    add_index :events, [:start_at, :topic], unique: true
  end
end
