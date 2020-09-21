module MonthCalendarHelper
  def getWeeks(startDay)
    first = startDay.beginning_of_month.beginning_of_week(:sunday)
    last = startDay.end_of_month.end_of_week(:sunday)
    (first..last).to_a.in_groups_of(7)
  end
end
