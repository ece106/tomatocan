class CreateTimeslots < ActiveRecord::Migration[5.2]
  def change
    create_table :timeslots do |t|
      t.integer :user_id
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end
end
