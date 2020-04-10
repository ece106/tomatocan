class DropTimeslots < ActiveRecord::Migration[5.2]
  def change
  	drop_table :timeslots
  end
end
