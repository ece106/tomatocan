require 'test_helper'

class EventTest < ActiveSupport::TestCase
  setup do
    #Basic data setup
    @eventT = Event.first

  end

  test "validates presence of usrid" do
    #usrid present
    assert @eventT.save, "User not saved with present usrid"

    #userid absent
    @eventT.usrid = nil
    assert_not @eventT.save, "Event saved with absent usrid"
  end
end
