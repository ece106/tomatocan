class AddRecurringToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :recurring, :text
  end
end
