require "test_helper"
require "capybara-screenshot/minitest"

class ControlPanelEventsList < ActionDispatch::IntegrationTest
  setup do
    @user           = users :one
    @test_event_one = events :three
    @test_event_two = events :four
    @past_event     = events :past_event

    sign_in

    visit "/#{@user.permalink}/controlpanel"
  end

  test "upcoming events has the correct events" do
    within("#event-list-table") do
      assert has_content? @test_event_one.name
      assert has_content? @test_event_one.start_at.strftime("%A %B %d, %Y at %I:%M %p")

      assert has_content? @test_event_two.name
      assert has_content? @test_event_two.start_at.strftime("%A %B %d, %Y at %I:%M %p")
    end
  end

  test "can edit event name in upcoming events panel" do
    within("#event-list-table") do
      click_on "Edit", match: :first
    end

    assert_equal current_path, edit_event_path(@test_event_one)

    page.has_css? "#event_name"
    page.has_css? "#event_desc"

    page.has_css? "#event_start_at_1i"
    page.has_css? "#event_start_at_2i"
    page.has_css? "#event_start_at_3i"
    page.has_css? "#event_start_at_4i"
    page.has_css? "#event_start_at_5i"

    page.has_css? "#event_end_at_1i"
    page.has_css? "#event_end_at_2i"
    page.has_css? "#event_end_at_3i"
    page.has_css? "#event_end_at_4i"
    page.has_css? "#event_end_at_5i"

    page.has_css? ".update-event-btn"
  end

  test "upcoming events has the correct count" do
    within("#event-list-table") do
      upcoming_events_count = find_all(".event-name").to_a.count
      assert_equal upcoming_events_count, 2
    end
  end

  test "past shows has the correct events" do
    within(".past-events-list") do
      assert has_content? @past_event.name
      assert has_content? @past_event.start_at.strftime("%A %B %d, %Y at %I:%M %p")
    end
  end

  test "past shows has the correct count" do
    within(".past-events-list") do
      past_events_count = find_all(".past-event-name").to_a.count
      assert_equal past_events_count, 2
    end
  end

  test "has livestream directions" do
    page.has_css? ".stream-directions-panel"
  end

  test "can set up future live show" do
    click_on class: "btn btn-lg btn-primary"

    assert_equal current_path, new_event_path

    page.has_css? "#event_name"
    page.has_css? "#event_desc"

    page.has_css? "#event_start_at_1i"
    page.has_css? "#event_start_at_2i"
    page.has_css? "#event_start_at_3i"
    page.has_css? "#event_start_at_4i"
    page.has_css? "#event_start_at_5i"

    page.has_css? "#event_start_end_1i"
    page.has_css? "#event_start_end_2i"
    page.has_css? "#event_start_end_3i"
    page.has_css? "#event_start_end_4i"
    page.has_css? "#event_start_end_5i"

    page.has_css? "eventSubmit"
  end

  test "can start live show" do
    click_on id: "stream-btn"

    assert current_path, "https://crowdpublishtv.herokuapp.com/#{@user.permalink}"
  end

  private

  def sign_in
    visit root_path

    click_on('Sign In', match: :first)

    fill_in(id: 'user_email', with: 'fake@fake.com')
    fill_in(id: 'user_password', with: 'user1234')

    click_on(class: 'form-control btn-primary')
  end

end
