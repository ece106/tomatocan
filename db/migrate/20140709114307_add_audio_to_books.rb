class AddAudioToBooks < ActiveRecord::Migration[4.2]
  def change
    add_column :books, :bookaudio, :string
  end
end
