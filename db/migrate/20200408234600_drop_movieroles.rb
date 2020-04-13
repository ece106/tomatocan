class DropMovieroles < ActiveRecord::Migration[5.2]
  def change
  	drop_table :movieroles
  end
end
