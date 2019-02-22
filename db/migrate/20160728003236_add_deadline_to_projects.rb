class AddDeadlineToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :deadline, :datetime
  end
end
