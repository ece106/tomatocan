require 'test_helper'

class EventTest < ActiveSupport::TestCase
  setup do
    #Basic data setup
    @eventT = Event.first
    @eventT2 = Event.find(3)
    @eventT3 = events(:non_recurring_event)
    @eventT4 = events(:recurring_event)
    @invalidFormat = ["http", ".co", ".com", ".net", ".tv", ".uk", ".ly", ".me",
      ".biz", ".mobi", ".cn", "kickstarter", "barnesandnoble", "smashwords",
      "itunes", "amazon", "eventbrite", "rsvpify", "evite", "meetup"]
  end

  test "validate presence of user_id" do
    #user_id present
    @eventT.user_id = events(:one).user_id  #Ensuring user_id is present
    assert @eventT.save, "Event not saved with present user_id"

    #user_id absent
    @eventT.user_id = nil
    assert_not @eventT.save, "Event saved with absent user_id"
  end

  test "generating a non recurring event" do
    events = @eventT3.calendar_events(@eventT3.start_at)
    flag = events.count == 1
    assert_equal(true, flag, failure_message = "Non-recurring event generated multiple instances")
  end

  test "generating recurring events" do
    events = @eventT4.calendar_events(@eventT4.start_at)
    flag = events[0].name.eql?(events[1].name)
    assert_equal(true, flag, failure_message = "Recurring events did not generate multiple instances")
  end

  test "validate presence of name" do
    #name present
    @eventT.name = events(:one).name  #Ensuring name is present
    assert @eventT.save, "Event not saved with present name"

    #name absent
    @eventT.name = nil
    assert_not @eventT.save, "Event saved with absent name"
  end

  test "validate presence of start_at" do
    #start_at present
    #Time with maximum time limit
    @eventT.end_at =   @eventT.start_at + 3.hour
    assert @eventT.save, "Event not saved with present start_at"
    #start_at absent
    @eventT.start_at = nil
    assert_not @eventT.save, "Event saved with absent start_at"
  end

  test "validate uniqueness of start_at based on topic" do
    #assert 2 different user_id can't have the same start_at on 1 topic"
    @eventT.start_at = "2021-12-11 11:00:00"
    @eventT.topic = "Conversations"
    @eventT.save!

    @eventT2.start_at = events(:confirmedUser_event).start_at
    @eventT2.topic = "Conversations"
    refute @eventT2.valid?, "Start_at must be unique on 1 topic"
    assert @eventT2.errors.messages[:start_at]

    #assert 2 different user_id can have the same start_at on different topic"
    @eventT2.topic = "Activism Halls"
    assert @eventT2.valid?, "2 start_ats on different topics is acceptable"
  end

  test "name without url" do
    evalFormat do |format|
      @eventT.name = events(:one).name + format
      assert @eventT.errors.messages[:name]
    end
  end

  test "desc without url" do
    evalFormat do |format|
      @eventT.desc = events(:four).desc + format
      assert @eventT.errors.messages[:desc]
    end
  end

  def evalFormat
    errorMsg = "Event saved with invalid format: "
    isInvalid = false
    @invalidFormat.each do |format|
      yield format
      isInvalid ||= @eventT.save
      if isInvalid then
        errorMsg.concat format
        break
      end
    end
    assert_not isInvalid, errorMsg
  end
  
end