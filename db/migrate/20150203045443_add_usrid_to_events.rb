class AddUsridToEvents < ActiveRecord::Migration
  def change
    add_column :events, :usrid, :integer
  end
end
