class RemoveFieldsFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :ustreamvid, :text
    remove_column :users, :ustreamsocial, :text
    remove_column :users, :pinterest, :string
    remove_column :users, :blogurl, :string
    remove_column :users, :profilepicurl, :string
    remove_column :users, :address, :string
    remove_column :users, :latitude, :float
    remove_column :users, :longitude, :float
    remove_column :users, :videodesc1, :string
    remove_column :users, :videodesc2, :string
    remove_column :users, :videodesc3, :string
    remove_column :users, :blogradio, :string
    remove_column :users, :blogtalkradio, :text
  end
end
