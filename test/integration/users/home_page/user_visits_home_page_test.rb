require 'test_helper'

class UserVisitsHomePageTest < ActionDispatch::IntegrationTest
  setup do
    @test_user = users :confirmedUser
    @event = events :one

    sign_in
  end

  test "should go to home after clicking on home" do
      within("div#navbarSupportedContent.collapse.navbar-collapse") do
        first(:xpath, "//a[@href='/']").click
        assert_equal current_path, root_path
      end
    end

  test "should go to home after clicking on logo in top left" do
    find("img[src*='/assets/yellow brain-0ef2bfbda1490e1f56a4b158dddc0cbfdfd21a4f7235049ffbb3f68b59f145ad.png']").click
    assert_equal current_path, root_path
  end

  test "should go to about page when clicking about in header"  do
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

  test "should go to DropIn Hours page when clicking Drop In Anytime in header"  do
    within("div#navbarSupportedContent.collapse.navbar-collapse") do
      first(:xpath, "//a[@href='/studyhall']").click
      assert_equal current_path, '/studyhall'
    end
  end

  test "should go to DropIn Hours page when clicking Drop-In link in New to ThinQ.tv? paragraph" do
    click_on("Drop-In")
    assert_equal current_path, '/studyhall'
  end

  ##
  # test "should go to next event page when clicking next event name under the countdown clock" do
  #  within("div#nextEventdiv.mt-1") do
  #    first(:xpath, "//a[@href='/events/']").click
  #    assert_equal current_path, '/events/'
  #  end
  # end
  ##

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

  test "should go to view profile after clicking on user name and clicking view profile"  do
  	click_on(class: "dropdown-toggle")
  	click_on("View Profile", match: :first)
  	assert_equal current_path, user_profile_path(@test_user.permalink)
  end

  test "should go to control panel after clicking on user name and clicking control panel"  do
  	click_on(class: "dropdown-toggle")
  	click_on("Control Panel", match: :first)
  	assert_equal current_path, user_controlpanel_path(@test_user.permalink)
  end

  test "should be able to sign out correctly" do
  	click_on("Sign out", match: :first)
  	assert_equal current_path, root_path
  end

   test "should be able to host a live conversation" do
    click_on("Post your Own Conversation", match: :first)
    assert_equal current_path, new_event_path
  end

   def sign_in
    visit root_path

    click_on('Sign In', match: :first)

    fill_in(id: 'user_email', with: 'thinqtesting@gmail.com')
    fill_in(id: 'user_password', with: 'user1234')

    click_on(class: 'form-control btn-primary')
  end
end
