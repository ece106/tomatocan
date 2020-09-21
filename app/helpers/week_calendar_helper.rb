module WeekCalendarHelper
  def getWeekDays
    today = Time.now - 5.hour
    end_of_week = today + 6.day
    (today.to_date..end_of_week.to_date).to_a
  end
end