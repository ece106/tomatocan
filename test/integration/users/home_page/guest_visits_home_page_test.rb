require 'test_helper'

class GuestVisitsHomePageTest < ActionDispatch::IntegrationTest
	setup do
    	visit root_path
	end

	test "should go to home after clicking on home" do
  		within("div#globalNavbar.collapse.navbar-collapse") do
  			click_on('Home', match: :first)
  			assert_equal current_path, root_path
  		end	
  	end

  	test "should go to about page when clicking about in header"  do
  	within("div#globalNavbar.collapse.navbar-collapse") do
  		click_on('About Us', match: :first)
  		assert_equal current_path, getinvolved_path
  	end	
  end 

  #dpc = discover previous conversations
  test "should go to dpc page when clicking on dpc in header"  do
  	within("div#globalNavbar.collapse.navbar-collapse") do
  		click_on("Have us on your Podcast", match: :first)
  		assert_equal current_path, drschaeferspeaking_path
  	end	
  end 

  test "should go to FAQ page when clicking on FAQ in header"  do
  	within("div.col-sm-2.col-sm-offset-1") do
  		click_on('FAQ', match: :first)
  		assert_equal current_path, faq_path
  	end	
	end

	test "should go to sign up when clicking get out the vote" do
		within("#homeWrapper") do
			click_on('See an example Live Video Conversation Room', match: :first)
			assert_equal current_path, youronlinemom_path
		end
	end
end
