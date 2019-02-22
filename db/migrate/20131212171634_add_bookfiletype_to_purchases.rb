class AddBookfiletypeToPurchases < ActiveRecord::Migration[4.2]
  def change
    add_column :purchases, :bookfiletype, :string
  end
end
