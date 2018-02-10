class AddRoleToMoviesUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :movies_users, :role, :string
  end
end
