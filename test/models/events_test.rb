require 'test_helper'

class EventTest < ActiveSupport::TestCase
  setup do
    #Basic data setup
    @eventT = Event.first
    @eventT2 = Event.find(3)
    @invalidFormat = ["http", ".co", ".com", ".net", ".tv", ".uk", ".ly", ".me",
      ".biz", ".mobi", ".cn", "kickstarter", "barnesandnoble", "smashwords",
      "itunes", "amazon", "eventbrite", "rsvpify", "evite", "meetup"]
  end

  test "validate presence of user_id" do
    #user_id present
    @eventT.user_id = events(:one).user_id  #Ensuring user_id is present
    assert @eventT.save, "Event not saved with present user_id"

    #userid absent
    @eventT.user_id = nil
    assert_not @eventT.save, "Event saved with absent user_id"
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

  test "name without url" do
    evalFormat do |format|
      @eventT.name = events(:one).name + format
    end
  end

  test "desc without url" do
    evalFormat do |format|
      @eventT.desc = events(:four).desc + format
    end
  end

  test "address without url" do
    evalFormat do |format|
      @eventT.address = "Testing Address"+ format
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

  test "endat_greaterthan_startat" do
    #end_at greater than start_at
    @eventT.end_at = Time.now
    @eventT.start_at = @eventT.end_at - 2.hours
    assert @eventT.save, "Not accepting events with end_at > start_at"

    @eventT.start_at = Time.now
    @eventT.end_at = @eventT.start_at - 2.hours
    assert_not @eventT.save, "Accepting events with start_at > end_at"
  end

  test "rsvpqs association" do
    assert @eventT2.rsvpqs.count > 0, "event is not associated to rsvpqs"
  end

  test "users association" do
    assert @eventT2.users.count > 0, "rsvpqs is not associated to users"
  end
end
