require 'test_helper'

class PurchaseMailerTest < ActionMailer::TestCase
  
  #As of June 2, 2020 all tests pass
  ##Getting a DEPRECATION WARNING:but that should not be an issue unless the website begins to use rails 6.1
  
  setup do
    @user = users(:one)
    @seller = users(:two)
    @mail_hash = {seller:@seller, user: users(:one), purchase:purchases(:one)}
		@merchandise = merchandises(:one)
  end
 
 #checks contents of purchase email and if it is enqueued
  test 'purchase saved email to,from,subject' do
		@mail_hash[:merchandise] = @merchandise 
    mail = PurchaseMailer.with(@mail_hash).purchase_saved
	
	assert_emails 1 do
		mail.deliver_later
	end
	
    assert_equal 'Your purchase has been confirmed', mail.subject
    assert_equal [@user.email],mail.to
    assert_equal ['info@ThinQ.tv'], mail.from
	assert_equal "", mail.body.to_s
	
  end
  
  #checks contents of donation_saved email and if it is enqueued
  test 'donation saved email to,from,subject' do
    mail = PurchaseMailer.with(@mail_hash).donation_saved
	
	assert_emails 1 do
		mail.deliver_later
	end
	
    assert_equal 'Your donation is appreciated', mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ['info@ThinQ.tv'], mail.from
	assert_equal "", mail.body.to_s
  end
	
	#checks contents of donation_recieved email and if it is enqueued
	test 'donation_received email to,from,subject' do
		mail = PurchaseMailer.with(@mail_hash).donation_received
		
		assert_emails 1 do
			mail.deliver_later
		end
		
		assert_equal "#{@user.name} has made a donation", mail.subject
		assert_equal [@seller.email], mail.to
		assert_equal ['info@ThinQ.tv'], mail.from
		assert_equal "", mail.body.to_s
	end
	
	#checks contents of merchandise email and if it is enqueued
	test 'purchase_received mail to,from,subject' do
		@mail_hash[:merchandise] = @merchandise
		mail = PurchaseMailer.with(@mail_hash).donation_received
		
		assert_emails 1 do
			mail.deliver_later
		end
		
		assert_equal "#{@user.name} has made a donation", mail.subject
		assert_equal [@seller.email], mail.to
		assert_equal ['info@ThinQ.tv'], mail.from
		assert_equal "", mail.body.to_s
	end
end