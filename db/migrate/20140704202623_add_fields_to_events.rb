class AddFieldsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :desc, :text
    add_column :events, :address, :string
    add_column :events, :rsvp, :string
    add_column :events, :user_id, :integer
  end
end
