class AddImportanceOfCharacterToPhases < ActiveRecord::Migration[5.1]
  def change
  	add_column :phases, :CharacterImportance, :string
  end
end
