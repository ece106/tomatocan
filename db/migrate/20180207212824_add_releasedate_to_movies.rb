class AddReleasedateToMovies < ActiveRecord::Migration[5.1]
  def change
    add_column :movies, :releasedate, :date
  end
end
