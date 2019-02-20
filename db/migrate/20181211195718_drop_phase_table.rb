class DropPhaseTable < ActiveRecord::Migration[5.2]
  def up
  	drop_table :phases
  end

  def down
  	raise ActiveRecord::IrreversibleMigration
  end
end
