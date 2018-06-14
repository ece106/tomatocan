class ChangeUstreamsocialFormatInUsers < ActiveRecord::Migration[4.2]
  def self.up
    change_column :users, :ustreamsocial, :text
  end
 
  def self.down
    change_column :users, :ustreamsocial, :string
  end

end
