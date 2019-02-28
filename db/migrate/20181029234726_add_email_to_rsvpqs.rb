class AddEmailToRsvpqs < ActiveRecord::Migration[5.2]
  def change
    add_column :rsvpqs, :email, :string
  end
end
