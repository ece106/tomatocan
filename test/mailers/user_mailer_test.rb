require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  # test "the truth" do
  #   assert true
  # end


  test "welcome email content" do
    user = User.new(name: 'user', password: "userpassword",
             password_confirmation: "userpassword",
             email: "email@email.com", permalink: "perma")
    mail = UserMailer.welcome_email(user)
    assert_equal "Welcome", mail.subject
    assert_equal [user.email] ,mail.to
    assert_equal ['crowdpublishtv.star@gmail.com'], mail.from

  end
  test 'purchase saved email content' do
    user = User.new(name: 'user', password: "userpassword",
                    password_confirmation: "userpassword",
                    email: "email@email.com", permalink: "perma")
    seller = User.first_or_create
    purchase = Purchase.new(user: user)
    merchandise = Merchandise.first_or_create
    mail = UserMailer.purchase_saved(seller,user,purchase,merchandise)
    assert_equal "Your purchase has been confirmed", mail.subject
    assert_equal [user.email] ,mail.to
    assert_equal ['crowdpublishtv.star@gmail.com'], mail.from

  end
  test 'donation saved email content' do
    user = User.new(name: 'user', password: "userpassword",
                     password_confirmation: "userpassword",
                     email: "email@email.com", permalink: "perma")
    seller = User.first_or_create
    purchase = Purchase.new(user: user)

    mail = UserMailer.donation_saved(seller,user,purchase)
    assert_equal 'Your donation is appreciated', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['crowdpublishtv.star@gmail.com'], mail.from

  end

end
