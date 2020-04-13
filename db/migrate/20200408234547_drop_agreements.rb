class DropAgreements < ActiveRecord::Migration[5.2]
  def change
  	drop_table :agreements
  end
end
