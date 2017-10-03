class AddYoutubeToMerchandises < ActiveRecord::Migration
  def change
    add_column :merchandises, :youtube, :string
  end
end
