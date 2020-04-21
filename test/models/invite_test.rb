require "test_helper"


class InviteTest < ActiveSupport::TestCase

  def setup
    @invite = invites(:one)
  end

  [:firstname].each do |field|
    test "#{field}_must_not_be_empty" do
      @invite.send "#{field}=", nil
      refute @invite.valid?
      refute_empty @invite.errors[field]
    end
    end
end

