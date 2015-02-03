class RemoveRsvpFromEvent < ActiveRecord::Migration
  def change
    remove_column :events, :rsvp, :string
  end
end
