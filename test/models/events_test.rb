require 'test_helper'

class EventTest < ActiveSupport::TestCase
  setup do
    #Basic data setup
    @userT = users :one
    @eventT = Event.new(events(:one))
    @eventT2 = Event.new(events(:three))

  end
end
