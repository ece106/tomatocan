class AddBlogtalkradioToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :blogtalkradio, :text
  end
end
