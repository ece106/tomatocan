class AddDurationInMinutesToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :duration_in_minutes, :integer
  end
end
