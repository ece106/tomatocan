class AddBlogradioToUsers < ActiveRecord::Migration
  def change
    add_column :users, :blogradio, :string
  end
end
