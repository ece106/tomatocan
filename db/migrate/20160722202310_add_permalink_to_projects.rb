class AddPermalinkToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :permalink, :string
  end
end
