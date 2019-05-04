class AddGuestAndInterviewerInformationToTimeslots < ActiveRecord::Migration[5.2]
  def change
    add_column :timeslots, :interviewer_user_id, :integer
    add_column :timeslots, :interviewer_name, :string
    add_column :timeslots, :interviewer_email, :string
    add_column :timeslots, :guest1_user_id, :integer
    add_column :timeslots, :guest1_name, :string

    add_column :timeslots, :guest1_email, :string
  end
end
