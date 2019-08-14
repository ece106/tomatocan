require 'test_helper'

class GuestVisitsHomePageTest < ActionDispatch::IntegrationTest
  setup do
    @user = users :one
    sign_in
  end

  #test "the truth" do
  #  assert true
  #end

  test "should go to home after clicking on home" do
  	within("div#globalNavbar.collapse.navbar-collapse") do
  		click_on('Home', match: :first)
  		assert_equal current_path, root_path
  	end	
  end

  test "should go to about page when clicking about in header"  do
  	within("div#globalNavbar.collapse.navbar-collapse") do
  		click_on('About', match: :first)
  		assert_equal current_path, aboutus_path
  	end	
  end 

  #dpc = discover previous conversations
  test "should go to dpc page when clicking on dpc in header"  do
  	within("div#globalNavbar.collapse.navbar-collapse") do
  		click_on("Discover Previous Conversations", match: :first)
  		assert_equal current_path, supportourwork_path
  	end	
  end 

  test "should go to FAQ page when clicking on FAQ in header"  do
  	within("div#globalNavbar.collapse.navbar-collapse") do
  		click_on('FAQ', match: :first)
  		assert_equal current_path, faq_path
  	end	
  end 

  test "should go to view profile after clicking on user name and clicking view profile"  do
  end 

  test "should go to control panel after clicking on user name and clicking control panel"  do
  end

  test "should be able to sign out" do
  end	


  def sign_in
    visit root_path

    click_on('Sign In', match: :first)

    fill_in(id: 'user_email', with: 'fake@fake.com')
    fill_in(id: 'user_password', with: 'user1234')

    click_on(class: 'form-control btn-primary')
  end
end
