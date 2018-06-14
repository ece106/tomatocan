class CreateProjects < ActiveRecord::Migration[4.2]
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :user_id
      t.text :mission
      t.string :projectpic

      t.timestamps
    end
  end
end
