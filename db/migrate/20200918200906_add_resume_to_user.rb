class AddResumeToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :resume, :string
  end
end
