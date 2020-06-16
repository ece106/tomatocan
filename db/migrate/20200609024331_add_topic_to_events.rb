class AddTopicToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :topic, :string
  end
end
