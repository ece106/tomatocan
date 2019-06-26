require 'test_helper'

class DeleteMeMailerTest < ActionMailer::TestCase
  test "delete_me_method" do
    mail = DeleteMeMailer.delete_me_method
    assert_equal "Delete me method", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
