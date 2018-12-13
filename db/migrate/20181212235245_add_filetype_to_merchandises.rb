class AddFiletypeToMerchandises < ActiveRecord::Migration[5.2]
  def change
    add_column :merchandises, :filetype, :string
  end
end
