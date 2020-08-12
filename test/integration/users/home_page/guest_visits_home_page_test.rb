require 'test_helper'

class GuestVisitsHomePageTest < ActionDispatch::IntegrationTest
	setup do
    	visit root_path
	end

	test "should go to home after clicking on home" do
  		within("div#navbarSupportedContent.collapse.navbar-collapse") do
  			first(:xpath, "//a[@href='/']").click
  			assert_equal current_path, root_path
  		end	
  	end

  test "should go to about page when clicking about us in header"  do
  	within("div#navbarSupportedContent.collapse.navbar-collapse") do
  		first(:xpath, "//a[@href='/getinvolved']").click
  		assert_equal current_path, '/getinvolved'
  	end	
  end 

  #jtt = join the team
  test "should go to jtt page when clicking on jtt in header"  do
    within("div#navbarSupportedContent.collapse.navbar-collapse") do
      first(:xpath, "//a[@href='/jointheteam']").click
      assert_equal current_path, '/jointheteam'
    end 
  end 

  test "should go to Activism Hall page when clicking Activism Hall in header"  do
    within("div#navbarSupportedContent.collapse.navbar-collapse") do
      first(:xpath, "//a[@href='/studyhall']").click
      assert_equal current_path, '/studyhall'
    end 
  end

  test 'should go to sign up page when clicking sign up button' do
    assert page.has_css? '.navbar-btn'
    assert page.has_link? 'Sign Up'
    find_link('Sign Up', match: :first).click
    assert_equal current_path, '/signup'
  end

  test 'should go to sign in page when clicking sign in button' do
    assert page.has_css? '.navbar-btn'
    assert page.has_link? 'Sign In'
    find_link('Sign In', match: :first).click
    assert_equal '/login', current_path
  end

  test "should go to FAQ page when clicking FAQ in footer"  do
    within("div#footer.row") do
      first(:xpath, "//a[@href='/faq']").click
      assert_equal current_path, '/faq'
    end 
  end

  test "should go to drschaeferspeaking page when clicking Invite Us to Speak in footer"  do
    within("div#footer.row") do
      first(:xpath, "//a[@href='/drschaeferspeaking']").click
      assert_equal current_path, '/drschaeferspeaking'
    end 
  end

  #ToS = Terms of Service
  test "should go to ToS page when clicking ToS in footer"  do
    within("div#footer.row") do
      first(:xpath, "//a[@href='/tos']").click
      assert_equal current_path, '/tos'
    end 
  end

  test "should go to Privacy page when clicking Privacy in footer"  do
    within("div#footer.row") do
      first(:xpath, "//a[@href='/privacy']").click
      assert_equal current_path, '/privacy'
    end 
  end

  test "should have a link for emailing website in footer" do
    within("div#footer.row") do
      assert page.has_link?('info@ThinQ.tv')
    end
  end

  test "images should exist for social media sharing buttons in footer" do
    email_img = "//footer/div/div/div[3]/div/a[4]/img"
    linkedin_img = "//footer/div/div/div[3]/div/a[3]/img"
    facebook_img = "//footer/div/div/div[3]/div/a[1]/img"
    twitter_img = "//footer/div/div/div[3]/div/a[2]/img"

    assert page.has_xpath? email_img
    assert page.has_xpath? linkedin_img
    assert page.has_xpath? facebook_img
    assert page.has_xpath? twitter_img
  end

  test "links should exist for social media sharing buttons in footer" do
    linkedin_link = "/html/body/footer/div/div/div[3]/div/a[3]"
    facebook_link = "/html/body/footer/div/div/div[3]/div/a[1]"
    twitter_link = "/html/body/footer/div/div/div[3]/div/a[2]"
    email_link = "/html/body/footer/div/div/div[3]/div/a[4]"

    assert page.has_xpath? linkedin_link
    assert page.has_xpath? facebook_link
    assert page.has_xpath? twitter_link
    assert page.has_xpath? email_link
  end
end
