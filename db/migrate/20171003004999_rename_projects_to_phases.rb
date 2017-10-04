class RenameProjectsToPhases < ActiveRecord::Migration
   def change
     rename_table :projects, :phases
   end 
 end