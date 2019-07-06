class SendEventReminderJob < ApplicationJob
  queue_as :SendEventReminderJob
	 
  def perform(user,event)	
		EventMailer.with(user: user, event: event).event_reminder.deliver_now
	end
end
