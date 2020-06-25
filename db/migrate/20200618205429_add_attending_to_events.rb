class AddAttendingToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :attending, :text, default: [], array:true
  end
end
