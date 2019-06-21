require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @user = users(:one)
    @seller = users(:two)
  end
  test "welcome email to,from,subject" do

    mail = UserMailer.welcome_email(@user)
    assert_equal "Welcome", mail.subject
    assert_equal [@user.email] ,mail.to
    assert_equal ['crowdpublishtv.star@gmail.com'], mail.from
  end
  test 'purchase saved email to,from,subject' do
    purchase = Purchase.new(user: @user)
    merchandise = Merchandise.first_or_create
    mail = UserMailer.purchase_saved(@seller,@user,purchase,merchandise)
    assert_equal "Your purchase has been confirmed", mail.subject
    assert_equal [@user.email] ,mail.to
    assert_equal ['crowdpublishtv.star@gmail.com'], mail.from
  end
  test 'donation saved email to,from,subject' do
    purchase = Purchase.new(user: @user)
    mail = UserMailer.donation_saved(@seller,@user,purchase)
    assert_equal 'Your donation is appreciated', mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ['crowdpublishtv.star@gmail.com'], mail.from

  end

end
