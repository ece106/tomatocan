class AddAudioToBooks < ActiveRecord::Migration
  def change
    add_column :books, :bookaudio, :string
  end
end
