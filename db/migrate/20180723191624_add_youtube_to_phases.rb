class AddYoutubeToPhases < ActiveRecord::Migration[5.2]
  def change
    add_column :phases, :youtube, :string
  end
end
