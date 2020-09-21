class CreateRsvpqs < ActiveRecord::Migration[4.2]
    def change
        unless table_exists? :rsvpqs
            create_table :rsvpqs do |t|
                t.integer :event_id
                t.integer :user_id
                t.integer :guests
                t.timestamps
            end
        end
    end
end
