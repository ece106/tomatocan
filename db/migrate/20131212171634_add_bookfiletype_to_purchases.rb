class AddBookfiletypeToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :bookfiletype, :string
  end
end
