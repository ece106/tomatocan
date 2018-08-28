class RemovePhaseIdFromMerchandise < ActiveRecord::Migration[5.2]
  def change
    remove_column :merchandises, :phase_id, :integer
  end
end
