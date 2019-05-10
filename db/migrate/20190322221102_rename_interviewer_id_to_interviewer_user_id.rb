class RenameInterviewerIdToInterviewerUserId < ActiveRecord::Migration[5.2]
  def change
  	rename_column :events, :interviewer_id, :interviewer_user_id
  end
end
