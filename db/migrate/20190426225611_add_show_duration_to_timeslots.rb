class AddShowDurationToTimeslots < ActiveRecord::Migration[5.2]
  def change
    add_column :timeslots, :show_duration, :integer
  end
end
