class Addemailtorsvpq < ActiveRecord::Migration[5.2]
  def change
  	add_column :rsvpqs, :email, :text
  end
end
