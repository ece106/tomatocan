class CreateAttendance < ActiveRecord::Migration[6.0]
  def change
    create_table :attendances do |t|
      t.integer :user_id
      t.integer :event_id
      t.timestamp :time_in
      t.timestamp :time_out
    end
  end
end
