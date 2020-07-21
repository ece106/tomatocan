class AddAttendedToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :attended, :integer, default: [], array:true
  end
end
