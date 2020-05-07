class ChangePhoneToBeStringInMessages < ActiveRecord::Migration[5.2]
  def change
    change_column :messages, :phone_number, :string
  end
end