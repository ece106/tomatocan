class RemoveDurationInMinutesFromAttendances < ActiveRecord::Migration[6.0]
  def change
    remove_column :attendances, :duration_in_minutes, :integer
  end
end
