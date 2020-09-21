class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.text :ustreamvid
      t.string :ustreamsocial
      t.string :twitter
      t.string :facebook
      t.string :pinterest
      t.string :youtube
      t.string :genre1
      t.string :genre2
      t.string :genre3
      t.string :blogurl
      t.string :profilepicurl
      t.string :profilepic
      t.integer :author
      t.text :about
      t.string :password_digest
      t.string :remember_token

      t.timestamps
    end
    add_index  :users, :remember_token
  end
end
