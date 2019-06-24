require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @user = users(:one)
    @seller = users(:two)
    @mail_hash = {seller:@seller, user: users(:one), purchase:purchases(:one)}
  end
  test 'welcome email to,from,subject' do
    mail = UserMailer.with(user: @user).welcome_email
    assert_equal "Welcome", mail.subject
    assert_equal [@user.email] ,mail.to
    assert_equal ['crowdpublishtv.star@gmail.com'], mail.from
  end
  test 'purchase saved email to,from,subject' do
    mail = UserMailer.with(user:@user,seller:@seller,purchase:purchases(:one),merchandise:merchandises(:one)).purchase_saved
    assert_equal 'Your purchase has been confirmed', mail.subject
    assert_equal [@user.email],mail.to
    assert_equal ['crowdpublishtv.star@gmail.com'], mail.from
  end
  test 'donation saved email to,from,subject' do
    mail = UserMailer.with(@mail_hash).donation_saved
    assert_equal 'Your donation is appreciated', mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ['crowdpublishtv.star@gmail.com'], mail.from

  end

end
