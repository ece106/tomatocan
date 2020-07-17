module WeekCalendarHelper
  def getWeekDays
    today = Date.today
    end_of_week = today + 6.day
    (today..end_of_week).to_a
  end
end
