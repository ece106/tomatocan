class AddBlogtalkradioToUsers < ActiveRecord::Migration
  def change
    add_column :users, :blogtalkradio, :text
  end
end
