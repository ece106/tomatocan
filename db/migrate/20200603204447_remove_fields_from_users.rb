class RemoveFieldsFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :ustreamvid
    remove_column :users, :ustreamsocial
    remove_column :users, :pinterest
    remove_column :users, :blogurl
    remove_column :users, :profilepicurl
    remove_column :users, :address
    remove_column :users, :latitude
    remove_column :users, :longitude
    remove_column :users, :videodesc1
    remove_column :users, :videodesc2
    remove_column :users, :videodesc3
    remove_column :users, :blogradio
    remove_column :users, :blogtalkradio
  end
end
