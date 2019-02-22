class CreateGroups < ActiveRecord::Migration[4.2]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :address
      t.float :latitude
      t.float :longitude
      t.integer :user_id
      t.text :about
      t.string :grouppic
      t.integer :type

      t.timestamps
    end
  end
end
