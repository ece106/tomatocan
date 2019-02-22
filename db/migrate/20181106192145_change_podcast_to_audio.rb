class ChangePodcastToAudio < ActiveRecord::Migration[5.2]
  def change
    rename_column :merchandises, :podcast, :audio
  end
end
