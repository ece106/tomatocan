class AddUserIdToMovie < ActiveRecord::Migration[5.1]
  def change
    add_column :movies, :user_id, :integer
    add_column :movies, :director, :string
  end
end
