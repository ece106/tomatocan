class AddProjToMerchandises < ActiveRecord::Migration[4.2]
  def change
    add_column :merchandises, :project_id, :integer
    add_column :merchandises, :deadline, :datetime
    add_column :merchandises, :goal, :float
  end
end
