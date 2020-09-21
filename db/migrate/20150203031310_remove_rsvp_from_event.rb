class RemoveRsvpFromEvent < ActiveRecord::Migration[4.2]
  def change
    remove_column :events, :rsvp, :string
  end
end
