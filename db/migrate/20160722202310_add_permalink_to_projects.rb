class AddPermalinkToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :permalink, :string
  end
end
