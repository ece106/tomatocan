class AddBlogradioToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :blogradio, :string
  end
end
