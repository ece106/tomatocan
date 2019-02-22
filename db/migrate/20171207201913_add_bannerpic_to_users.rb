class AddBannerpicToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :bannerpic, :string
  end
end
