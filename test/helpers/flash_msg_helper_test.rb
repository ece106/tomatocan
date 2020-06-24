require 'test_helper'

class FlashMsgHelperTest < ActionView::TestCase
  setup do
    @defaultBootstrapAlerts = ["warning", "info", "success", "danger", "light",
      "dark", "primary","secundary"]
  end
  test "Keys formated properly" do
    assert_equal "success", format("notice")
    assert_equal "danger", format("alert")
    #Default bootstrap alert types
    @defaultBootstrapAlerts.each do |alertType|
      assert_equal alertType, format(alertType)
    end
  end
end
