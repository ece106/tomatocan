module CalerHelper

  def month_link(month_date)
    link_to(I18n.localize(month_date, :format => "%B"), {:month => month_date.month, :year => month_date.year})
  end
  
  # custom options for this calendar
  def event_calendar_opts
    { 
      :year => @year,
      :month => @month,
      :event_strips => @event_strips,
      :month_name_text => I18n.localize(@shown_month, :format => "%B %Y"),
      :previous_month_text => "<< " + month_link(@shown_month.prev_month),
      :next_month_text => month_link(@shown_month.next_month) + " >>"    }
  end

  def event_calendar
    # args is an argument hash containing :event, :day, and :options
    calendar event_calendar_opts do |args|
      event = args[:event]
      %(<a href="/events/#{event.id}" title="#{h(event.name)}">#{h(event.name)}</a>)
    end
  end


	def caler(date = Date.today, &block)
		Caler.new(self, date, block).table
	end

	class Caler < Struct.new(:view, :date, :callback)
		HEADER = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
		START_DAY = :sunday

		delegate :content_tag, to: :view

		def table
			content_tag :table, class: "caler" do
				header + week_rows
			end
		end

		def header 
			content_tag :tr do
				HEADER.map { |day| content_tag :th, day }.join.html_safe
			end
		end

		def week_rows
			weeks.map do |week|
				content_tag :tr do
					week.map { |day| day_cell(day) }.join.html_safe
				end
			end.join.html_safe
		end

		def day_cell(day)
			content_tag :td, view.capture(day, &callback), class: day_classes(day)
		end

		def day_classes(day)
			classes = []
			classes << "today" if day == Date.today
			classes << "notmonth" if day.month != date.month
			classes.empty? ? nil : classes.join(" ")
		end 


		def weeks
			first = date.beginning_of_month.beginning_of_week(START_DAY)
			last = date.end_of_month.end_of_week(START_DAY)
			(first..last).to_a.in_groups_of(7)
		end
	end
end
