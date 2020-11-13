class AddChatroomToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :chatroom, :string, :default => "thinqtv"
  end
end
