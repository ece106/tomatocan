class CreateInvites < ActiveRecord::Migration[5.2]
  def change
    create_table :invites do |t|
    	t.string  :firstname
    	t.string  :lastname, null: false
    	t.string  :email, null: false
    	t.integer :phone_number
    	t.text    :description, null: false
    	
    	t.timestamps null: false

    end
  end
end
