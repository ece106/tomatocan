class RenameProjectsToPhases < ActiveRecord::Migration[4.2]
   def change
     rename_table :projects, :phases
   end 
 end