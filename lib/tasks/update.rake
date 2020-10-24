namespace :update do

  desc "Rake task to update time out in attendances table for users that are still in the conversation after the conversation end time"
  task update_attendances_time_out: :environment do
    # some book keeping
    puts "Closing up conversations [First]"
    puts Time.now

    # check if any conversation had just ended
    event = Event.conversation_ended
    if event.present?
      # some book keeping
      puts "Conversation found"
      puts event.id
      # find attendances of converation where time_out column is empty (people still in conversation)
      attended = Attendance.where( "event_id = ?", event.id )
                            .where( time_out: [nil, ""] )
      # update time_out column to end time of conversation (current time)
      attended.each do |attendance_record|
        attendance_record.time_out = event.end_at
        attendance_record.save
      end
      puts "Attendance table times fixed"
    else
      puts "No conversation to update attendances for"
    end
  end

  desc "Rake task to update users reputation score after a conversation"
  # this task depends on :update_attendances_time_out to run first
  task update_users_reputation_score: [:update_attendances_time_out, :environment] do
    # some book keeping
    puts "Updating user reputation scores [Second]"
    puts Time.now

    # check if any conversation had just ended
    event = Event.conversation_ended
    if event.present?
      # some book keeping
      puts "Conversation found"
      puts event.id
      # find first attendance of conversation host
      host_attendance_record = Attendance.where( "event_id = ? AND user_id = ?", event.id, event.user_id ).first
      host = User.find(event.user_id)
      if (event.start_at + 5.minutes < host_attendance_record.time_in) && (event.start_at + 15.minutes > host_attendance_record.time_in) 
        # increase host reputation score by 10 if they joined the conversation 5-15 minutes late
        puts "Host was late by 5 minutes"
        User.update(host.id, reputation_score: host.reputation_score + 10)
      elsif (event.start_at + 15.minutes < host_attendance_record.time_in) && (event.start_at + 20.minutes > host_attendance_record.time_in) 
        # decrease host reputation score by 10 if they joined the conversation 15-20 minutes late
        puts "Host was late by 15 minutes"
        User.update(host.id, reputation_score: host.reputation_score - 10)
      elsif event.start_at + 20.minutes < host_attendance_record.time_in
        # decrease host reputation score by 10 if they joined the conversation more than 20 minutes late
        puts "Host was late by 20 minutes"
        User.update(host.id, reputation_score: host.reputation_score - 20)
      else 
        # increase host reputation score by 20 if there were no attendance issues
        puts "Host had no attendance issues"
        User.update(host.id, reputation_score: host.reputation_score + 20)
      end
      
      # find general attendances of converation (not host attendances) grouped by user_id
      attended = Attendance.where( "event_id = ? AND user_id != ?", event.id, event.user_id )
                            .group("user_id")
                            .sum("time_out - time_in")
                            # .sum((("time_out - time_in")/60).to_i)
      puts "Record of attendance duration by user ids"
      puts attended
      attended.each do |key, attendance_duration|
        puts key
        puts attendance_duration
        puts Time.parse(attendance_duration).min.to_i
        # puts (attendance_duration/60).to_i > 30
        user = User.find_by( "id = ?", key )
        if Time.parse(attendance_duration).min.to_i > 30
          # increase user reputation score by 10 if they stayed in the conversation by more than 30 minutes
          puts "This user stayed for longer than 30 minutes"
          User.update(key, reputation_score: user.reputation_score + 10)
        else
          puts "This user was not in the conversation for at aleast 30 minutes"
        end
      end
    else
      puts "No conversation to update reputation score for"
    end
  end

end
