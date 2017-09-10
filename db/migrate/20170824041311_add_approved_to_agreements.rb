class AddApprovedToAgreements < ActiveRecord::Migration
  def change
    add_column :agreements, :approved, :datetime
  end
end
