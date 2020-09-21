class RenameProjectsToPhases < ActiveRecord::Migration[5.0]
   def change
     rename_table :projects, :phases
   end 
 end