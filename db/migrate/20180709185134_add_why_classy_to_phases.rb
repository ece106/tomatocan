class AddWhyClassyToPhases < ActiveRecord::Migration[5.2]
  def change
  	add_column :phases, :why_classy, :string
  end
end
