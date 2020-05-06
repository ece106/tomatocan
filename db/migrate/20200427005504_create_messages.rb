class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
    	t.string  :fullname, null: false
    	t.string  :email, null: false
    	t.string  :phone_number
		t.string  :subject, null: false    	
    	t.text    :message, null: false
    	
    	t.timestamps null: false
    end
  end
end
