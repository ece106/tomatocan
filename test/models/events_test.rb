require 'test_helper'

class EventTest < ActiveSupport::TestCase
  setup do
    #Basic data setup
    @eventT = Event.first
    @invalidFormat = ["http", ".co", ".com", ".net", ".tv", ".uk", ".ly", ".me",
      ".biz", ".mobi", ".cn", "kickstarter", "barnesandnoble", "smashwords",
      "itunes", "amazon", "eventbrite", "rsvpify", "evite", "meetup"]
  end

  test "validate presence of usrid" do
    #usrid present
    @eventT.usrid = events(:one).usrid  #Ensuring usrid is present
    assert @eventT.save, "Event not saved with present usrid"

    #userid absent
    @eventT.usrid = nil
    assert_not @eventT.save, "Event saved with absent usrid"
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

  test "Name without url" do
    name = @eventT.name
    errorMsg = "Event saved with invalid name: "
    isInvalid = false
    @invalidFormat.each do |format|
      @eventT.name = name + format
      isInvalid ||= @eventT.save
      if isInvalid then
        errorMsg.concat @eventT.name
        break
      end
    end
    assert_not isInvalid, errorMsg
  end
end
