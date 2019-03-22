class AddInterviewerToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :interviewer_id, :integer
    add_column :events, :interviewer_name, :string
    add_column :events, :interviewer_email, :string
  end
end
