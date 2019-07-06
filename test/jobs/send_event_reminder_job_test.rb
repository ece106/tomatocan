require 'test_helper'

class SendEventReminderJobTest < ActiveJob::TestCase
  setup do
	  @event = events(:one)
	  @user = users(:one)
  end
  
	test 'test SendEventReminderJob queues mail' do
		start = @event.start_at - 2.days
		assert_enqueued_with(job: SendEventReminderJob) do	
			SendEventReminderJob.set(wait_until: start ).perform_later(@user,@event)
		end
	end 
end
