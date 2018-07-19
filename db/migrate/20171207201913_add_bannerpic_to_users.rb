class AddBannerpicToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :bannerpic, :string
  end
end
