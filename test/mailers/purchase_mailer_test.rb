require 'test_helper'

class PurchaseMailerTest < ActionMailer::TestCase
  
  setup do
    @user = users(:one)
    @seller = users(:two)
    @mail_hash = {seller:@seller, user: users(:one), purchase:purchases(:one)}
		@merchandise = merchandises(:one)
  end
 
  test 'purchase saved email to,from,subject' do
		@mail_hash[:merchandise] = @merchandise 
    mail = PurchaseMailer.with(@mail_hash).purchase_saved
    assert_equal 'Your purchase has been confirmed', mail.subject
    assert_equal [@user.email],mail.to
    assert_equal ['crowdpublishtv.star@gmail.com'], mail.from
  end
  test 'donation saved email to,from,subject' do
    mail = PurchaseMailer.with(@mail_hash).donation_saved
    assert_equal 'Your donation is appreciated', mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ['crowdpublishtv.star@gmail.com'], mail.from
	end
	test 'donation_received email to,from,subject' do
		mail = PurchaseMailer.with(@mail_hash).donation_received
		assert_equal "#{@user.name} has made a donation", mail.subject
    assert_equal [@seller.email], mail.to
    assert_equal ['crowdpublishtv.star@gmail.com'], mail.from
	end
	test 'purchase_received mail to,from,subject' do
	  @mail_hash[:merchandise] = @merchandise
		mail = PurchaseMailer.with(@mail_hash).donation_received
		assert_equal "#{@user.name} has made a donation", mail.subject
    assert_equal [@seller.email], mail.to
    assert_equal ['crowdpublishtv.star@gmail.com'], mail.from
	end
end
