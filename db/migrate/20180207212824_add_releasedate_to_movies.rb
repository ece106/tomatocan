class AddReleasedateToMovies < ActiveRecord::Migration[4.2]
  def change
    add_column :movies, :releasedate, :date
  end
end
