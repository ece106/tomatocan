class CreateInvites < ActiveRecord::Migration[6.0]
  def change
    create_table :invites do |t|
      t.string :phone_number
      t.string :country_code
      t.string :relationship
      t.string :preferred_name
      t.integer :sender_id
      t.text :custom_message

      t.timestamps
    end
  end
end
