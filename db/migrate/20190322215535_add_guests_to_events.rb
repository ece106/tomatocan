class AddGuestsToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :guest1_user_id, :integer
    add_column :events, :guest1_name, :string
    add_column :events, :guest1_email, :string
    add_column :events, :guest2_user_id, :integer
    add_column :events, :guest2_name, :string
    add_column :events, :guest2_email, :string
  end
end
