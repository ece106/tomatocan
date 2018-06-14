class CreateAgreements < ActiveRecord::Migration[4.2]
  def change
    create_table :agreements do |t|
      t.integer :project_id
      t.integer :group_id

      t.timestamps
    end
  end
end
