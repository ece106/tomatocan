class CreateEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.string :userid
      t.string :event_id
      t.string :email

      t.timestamps
    end
  end
end
