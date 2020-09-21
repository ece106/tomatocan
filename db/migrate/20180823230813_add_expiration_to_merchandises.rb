class AddExpirationToMerchandises < ActiveRecord::Migration[5.2]
  def change
    add_column :merchandises, :expiration, :datetime
  end
end
