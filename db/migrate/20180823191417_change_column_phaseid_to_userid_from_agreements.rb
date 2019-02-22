class ChangeColumnPhaseidToUseridFromAgreements < ActiveRecord::Migration[5.2]
  def change
    rename_column :agreements, :phase_id, :user_id
  end
end

