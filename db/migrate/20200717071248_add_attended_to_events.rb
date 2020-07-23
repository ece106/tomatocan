class AddAttendedToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :attended, :text, default: [], array:true
  end
end
