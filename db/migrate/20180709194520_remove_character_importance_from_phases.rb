class RemoveCharacterImportanceFromPhases < ActiveRecord::Migration[5.2]
  def change
    remove_column :phases, :CharacterImportance, :string
  end
end
