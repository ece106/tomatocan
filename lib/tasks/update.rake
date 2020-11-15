namespace :update do

  desc "Rake task to update time out in attendances table for users that are still in the conversation after the conversation end time"
  task update_attendances_time_out: :environment do
    # check if any conversation had just ended
    event = Event.conversation_ended
    if event.present?
      # find attendances of converation where time_out column is empty (people are still in conversation)
      attended = Attendance.where( "event_id = ?", event.id )
                            .where( time_out: [nil, ""] )

      # update time_out column to end time of conversation (current time)
      attended.each do |attendance_record|
        attendance_record.time_out = event.end_at
        attendance_record.save
      end
    end
  end

  desc "Rake task to update users reputation score after a conversation"
  # this task depends on :update_attendances_time_out to run first
  task update_users_reputation_score: [:update_attendances_time_out, :environment] do
    # check if any conversation had just ended
    event = Event.conversation_ended
    if event.present?
      # find first attendance of conversation host 
      host_attendance_record = Attendance.where( "event_id = ? AND user_id = ?", event.id, event.user_id ).first
      host = User.find(event.user_id)

      if (event.start_at + 5.minutes < host_attendance_record.time_in) && (event.start_at + 10.minutes > host_attendance_record.time_in) 
        # increase host reputation score by 10 if they joined the conversation 5-10 minutes late
        User.update(host.id, reputation_score: host.reputation_score + 10)
      elsif (event.start_at + 10.minutes < host_attendance_record.time_in) && (event.start_at + 15.minutes > host_attendance_record.time_in) 
        # decrease host reputation score by 10 if they joined the conversation 10-15 minutes late
        User.update(host.id, reputation_score: host.reputation_score - 10)
      elsif event.start_at + 15.minutes < host_attendance_record.time_in
        # decrease host reputation score by 10 if they joined the conversation more than 15 minutes late
        User.update(host.id, reputation_score: host.reputation_score - 20)
      else 
        # increase host reputation score by 20 if there were no attendance issues
        puts "Host had no attendance issues"
        User.update(host.id, reputation_score: host.reputation_score + 20)
      end
      
      # find general attendances of converation (not host attendances) grouped by user_id and sum their attendance duration times
      attended = Attendance.where( "event_id = ? AND user_id != ?", event.id, event.user_id )
                            .group("user_id")
                            .sum("time_out - time_in")

      attended.each do |key, attendance_duration|
        user = User.find_by( "id = ?", key )
        if Time.parse(attendance_duration).min.to_i > 30
          # increase user reputation score by 10 if they stayed in the conversation by more than 30 minutes
          User.update(key, reputation_score: user.reputation_score + 10)
        end
      end
    end
  end
end
