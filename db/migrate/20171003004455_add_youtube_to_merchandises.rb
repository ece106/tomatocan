class AddYoutubeToMerchandises < ActiveRecord::Migration[4.2]
  def change
    add_column :merchandises, :youtube, :string
  end
end
