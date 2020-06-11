require 'test_helper'

class UserVisitsHomePageTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :one
    @event = events :one

    sign_in
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

  test "should go to view profile after clicking on user name and clicking view profile"  do
  	click_on(class: "dropdown-toggle")
  	click_on("View Profile", match: :first)
  	assert_equal current_path, user_profile_path(@user.permalink)
  end

  test "should go to control panel after clicking on user name and clicking control panel"  do
  	click_on(class: "dropdown-toggle")
  	click_on("Control Panel", match: :first)
  	assert_equal current_path, user_controlpanel_path(@user.permalink)
  end

  test "should be able to sign out correctly" do
  	click_on("Sign out", match: :first)
  	assert_equal current_path, root_path
  end	

   test "should be able to host a live conversation" do
    within("div#countdown_clock") do
      click_on("Post your Own Conversation", match: :first)
      assert_equal current_path, new_event_path
    end 
  end  

  test "should show event on home page" do
     assert has_content? @event.name
     #within("div#calendar.row") do
      #assert page.has_button?('RSVPsubmit')
      #click_on(id: "RSVPsubmit")
    #end
  end  

  test "should be able to add my own conversation" do
    within("div#countdown_clock.row") do
      click_on("Post your Own Conversation", match: :first)
      assert_equal current_path, new_event_path
    end 
  end  


  test "should go to FAQ page when clicking on FAQ in footer"  do
  	within("div.col-sm-2.col-sm-offset-1") do
  		click_on('FAQ', match: :first)
  		assert_equal current_path, faq_path
  	end	
  end

  #tos = terms of service
  test "should go to tos page when clicking on tos in footer"  do
  	within("div.col-sm-2.col-sm-offset-1") do
  		click_on("Terms of Service", match: :first)
  		assert_equal current_path, tos_path
  	end	
  end  

  test "images should exist for social media sharing buttons in footer" do
    email_img = "//html/body/footer/div/div/div[3]/div/a[4]/img"
    linkedin_img = "//html/body/footer/div/div/div[3]/div/a[3]/img"
    facebook_img = "//html/body/footer/div/div/div[3]/div/a[1]/img"
    twitter_img = "//html/body/footer/div/div/div[3]/div/a[2]/img"

    assert page.has_xpath? email_img
    assert page.has_xpath? linkedin_img
    assert page.has_xpath? facebook_img
    assert page.has_xpath? twitter_img
  end

   test "should be a link for emailing website in footer" do
    within("div#footer.row") do
      assert page.has_link?('info@ThinQ.tv')
    end
  end 

  test "links should exist for social media sharing buttons in footer" do
    linkedin_link = "html body footer div.container-fluid div#footer.row div.col-sm-2 div.social-share-button a img"
    facebook_link = "html body footer div.container-fluid div#footer.row div.col-sm-2 div.social-share-button a img"
    twitter_link = "html body footer div.container-fluid div#footer.row div.col-sm-2 div.social-share-button a img"
    email_link = "html body footer div.container-fluid div#footer.row div.col-sm-2 div.social-share-button a img"

    assert page.has_css? twitter_link
    assert page.has_css? facebook_link
    assert page.has_css? linkedin_link
    assert page.has_css? email_link
  end

  def sign_in
    visit root_path

    click_on('Sign In', match: :first)

    fill_in(id: 'user_email', with: 'fake@fake.com')
    fill_in(id: 'user_password', with: 'user1234')

    click_on(class: 'form-control btn-primary')
  end
end
