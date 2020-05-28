require 'test_helper'

class EventTest < ActiveSupport::TestCase
  setup do
    #Has many test
    #Usersd
    @userT = users :one
    #Events that belong to user :oned
    @eventT = Event.new(events(:one))
    @eventT2 = Event.new(events(:three))
    #Create instance of event model
  end
end
