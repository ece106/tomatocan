class AddRoledescToMoviesUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :movies_users, :roledesc, :string
  end
end
