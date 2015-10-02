class CreateRsvpqs < ActiveRecord::Migration
  def change
    create_table :rsvpqs do |t|
      t.integer :event_id
      t.integer :user_id
      t.integer :guests

      t.timestamps
    end
  end
end
