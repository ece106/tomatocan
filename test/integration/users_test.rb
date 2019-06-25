require 'test_helper'


class UsersTest < ActionDispatch::IntegrationTest
    include Capybara::DSL
    include Capybara::Minitest::Assertions
    Capybara::Screenshot.autosave_on_failure = false
    setup do
    visit ('/')
    click_on('Sign In', match: :first)
    fill_in(id: 'user_email', with: 'fake@fake.com')
    fill_in(id: 'user_password', with: 'user1234')
    click_on(class: 'form-control btn-primary')
end

test "Should_view_profileinfo" do
    click_on('Discover Talk Show Hosts')
    assert_text ('Discussion Hosts')
end
test "Should_sign_up" do
    click_on('Sign out')
    click_on('Sign Up', match: :first)
    fill_in(id:'user_name', with: 'name2')
    fill_in(id:'user_email', with: 'e2@gmail.com')
    fill_in(id:'user_permalink', with:'username2')
    fill_in(id:'user_password', with: 'password2', :match => :prefer_exact)
    fill_in(id:'user_password_confirmation', with:'password2')
    click_on(class: 'form-control btn-primary')
    assert_text ('Sign out')
end
test "Should_sign_up_and_then_out" do
    click_on('Sign out')
    click_on('Sign Up', match: :first)
    fill_in(id:'user_name', with: 'name2')
    fill_in(id:'user_email', with: 'e2@gmail.com')
    fill_in(id:'user_permalink', with:'username2')
    fill_in(id:'user_password', with: 'password2', :match => :prefer_exact)
    fill_in(id:'user_password_confirmation', with:'password2')
    click_on(class: 'form-control btn-primary')
    click_on('Sign out')
    assert_text('Sign Up')
end
test "Should_sign_up_and_then_out_and_then_back_in" do
    click_on('Sign out')
    click_on('Sign Up', match: :first)
    fill_in(id:'user_name', with: 'name2')
    fill_in(id:'user_email', with: 'e2@gmail.com')
    fill_in(id:'user_permalink', with:'username2')
    fill_in(id:'user_password', with: 'password2', :match => :prefer_exact)
    fill_in(id:'user_password_confirmation', with:'password2')
    click_on(class: 'form-control btn-primary')
    click_on('Sign out')
    click_on('Sign In')
    fill_in(id:'user_email', with: 'e2@gmail.com')
    fill_in(id:'user_password', with: 'password2', :match => :prefer_exact)
    click_on(class: 'form-control btn-primary')
    assert_text ('Sign out')
    
end

test "Should_see_edit_profile_in_control_panel" do
    click_on(class: 'dropdown-toggle')
    click_on('Control Panel')
    assert_text('Edit Profile')
end
test "Should_change_genre1" do
    click_on(class: 'dropdown-toggle')
    click_on('Control Panel')
    fill_in(id:'user_genre1',with:'Genre1')
    click_on(id:'saveProfileButton',:match => :first)
    assert_text('Genre1')
end
test "Should_change_genre2_with_genre1_existing" do
    click_on(class: 'dropdown-toggle')
    click_on('Control Panel')
    fill_in(id:'user_genre1',with:'Genre1')
    fill_in(id:'user_genre2',with:'Genre2')
    click_on(id:'saveProfileButton',:match => :first)
    assert_text('Genre2')
end
test "Should_change_genre3_with_genre1_existing" do
    click_on(class: 'dropdown-toggle')
    click_on('Control Panel')
    fill_in(id:'user_genre1',with:'Genre1')
    fill_in(id:'user_genre3',with:'Genre3')
    click_on(id:'saveProfileButton',:match => :first)
    assert_text('Genre3')
end
test "Should_change_password" do
    click_on(class: 'dropdown-toggle')
    click_on('Control Panel')
    click_on('Account')
    click_on('Change Password')
    fill_in(id:'user_password_confirmation',with: 'password1', :match => :prefer_exact)
    fill_in(id:'user_password', with: 'password1', :match => :prefer_exact)
    click_on("Save Profile")
    click_on('Sign out')
    click_on('Sign In', match: :first)
    fill_in(id:'user_email', with: 'fake@fake.com')
    fill_in(id:'user_password', with: 'password1')
    click_on(class: 'form-control btn-primary')
    assert_text('Offer Rewards & Receive Donations')
end
test "Should_change_email" do
    click_on(class: 'dropdown-toggle')
    click_on('Control Panel')
    click_on('Account')
    fill_in(id:'user_email', with: 'e2@mail.com')
    click_on(id:'saveProfileButton',:match => :first)
    assert_text('Videos')
end
test "Should_not_change_email"do
    click_on(class: 'dropdown-toggle')
    click_on('Control Panel')
    click_on('Account')
    fill_in(id:'user_email', with: 'e2')
    click_on(id:'saveProfileButton',:match => :first)
    refute_title('Videos')
end
test "Should_show_video" do
    click_on('Discover Talk Show Hosts')
    assert_text('Phineas')
end
test "Should_not_show_video" do
    click_on('Discover Talk Show Hosts')
    refute_title('name2')
    
end
test "Should_not_show_other_controlpanel" do
    visit('http://localhost:3000/user1/controlpanel')
    refute_title('Edit Profile')
end
test 'Should_fail_change_password' do
    click_on(class: 'dropdown-toggle')
    click_on('Control Panel')
    click_on('Account')
    click_on('Change Password')
    fill_in(id:'user_password_confirmation',with: 'password', :match => :prefer_exact)
    fill_in(id:'user_password', with: 'password1', :match => :prefer_exact)
    click_on("Save Profile")
    assert_text('Passwords do not match')
end
#These tests are in progress
test 'Should_see_product' do
    click_on('Sign out')
    click_on('Discover Talk Show Hosts')
    click_link('Phineas')
    assert_text('user1 product')
end
test 'Should_change_name' do
    click_on(class: 'dropdown-toggle')
    click_on('Control Panel')
    fill_in(id:'user_name', with:'names')
    click_on(id:'saveProfileButton',:match => :first)
    assert_text('names')
end
test 'Should_cancel' do
    click_on(class: 'dropdown-toggle')
    click_on('Control Panel')
    click_on(id:"cancelProfileButton",:match => :first)
    assert_text("Phineas's Videos")
end
test 'Should order' do
    visit('http://localhost:3000/')
    click_on('Discover Talk Show Hosts')
    click_link('Phineas')
    click_on('Buy for $1.50')
    assert_text('If you are purchasing')
end
test 'Should_host_logged_out' do
    click_on('Sign out')
    click_on('Host A Show')
    assert_text('You need to sign in or sign up before continuing.')
end
test 'Should_see_sign_up_not_logged_in' do
    click_on('Sign out')
    within('div#heroImage.row') do
        assert_text('Sign Up')
    end
end
test 'Should_see_offer_rewards_logged_in' do
    within('div#heroImage.row') do
        assert_text('Offer Rewards')
    end
end

    test "Should say email was taken when same user attempts sign up twice" do
		click_on('Sign out')
		click_on('Sign Up', match: :first)
		fill_in(id:'user_name', with: 'Phineas')
		fill_in(id:'user_email', with: 'fake@fake.com')
		fill_in(id:'user_permalink', with:'user1')
		fill_in(id:'user_password', with: 'password', :match => :prefer_exact)
		fill_in(id:'user_password_confirmation', with:'password')
		click_on(class: 'form-control btn-primary')
		assert_text 'Email has already been taken'
	end

	test "Should say permalink was taken when same user attempts sign up twice" do
		click_on('Sign out')
		click_on('Sign Up', match: :first)
		fill_in(id:'user_name', with: 'Phineas')
		fill_in(id:'user_email', with: 'fake@fake.com')
		fill_in(id:'user_permalink', with:'user1')
		fill_in(id:'user_password', with: 'password', :match => :prefer_exact)
		fill_in(id:'user_password_confirmation', with:'password')
		click_on(class: 'form-control btn-primary')
		assert_text 'Permalink has already been taken'
	end

	test "Should say email was already taken when new user signs up with existing email" do
		click_on('Sign out')
		click_on('Sign Up', match: :first)
		fill_in(id:'user_name', with: 'name')
		fill_in(id:'user_email', with: 'fake@fake.com')
		fill_in(id:'user_permalink', with:'newusername')
		fill_in(id:'user_password', with: 'password', :match => :prefer_exact)
		fill_in(id:'user_password_confirmation', with:'password')
		click_on(class: 'form-control btn-primary')
		assert_text 'Email has already been taken'
	end

	test "Should not say permalink was already taken when new user signs up with existing email" do
		click_on('Sign out')
		click_on('Sign Up', match: :first)
		fill_in(id:'user_name', with: 'name')
		fill_in(id:'user_email', with: 'fake@fake.com')
		fill_in(id:'user_permalink', with:'newusername')
		fill_in(id:'user_password', with: 'password', :match => :prefer_exact)
		fill_in(id:'user_password_confirmation', with:'password')
		click_on(class: 'form-control btn-primary')
		refute_text 'Permalink has already been taken'
	end

	test "Should say permalink was already taken when existing user signs up with new email" do
		click_on('Sign out')
		click_on('Sign Up', match: :first)
		fill_in(id:'user_name', with: 'name')
		fill_in(id:'user_email', with: 'newe@gmail.com')
		fill_in(id:'user_permalink', with:'user1')
		fill_in(id:'user_password', with: 'password', :match => :prefer_exact)
		fill_in(id:'user_password_confirmation', with:'password')
		click_on(class: 'form-control btn-primary')
		assert_text 'Permalink has already been taken'
	end

	test "Should not say email was already taken when existing user signs up with new email" do
		click_on('Sign out')
		click_on('Sign Up', match: :first)
		fill_in(id:'user_name', with: 'name')
		fill_in(id:'user_email', with: 'newe@gmail.com')
		fill_in(id:'user_permalink', with:'user1')
		fill_in(id:'user_password', with: 'password', :match => :prefer_exact)
		fill_in(id:'user_password_confirmation', with:'password')
		click_on(class: 'form-control btn-primary')
		refute_text 'Email has already been taken'
	end		

	test "Should_visit_FAQ1" do
		within('div#globalNavbar.collapse.navbar-collapse') do
			click_on(text: 'FAQ')
		end
		assert_text('accessing my mic or webcam')	
	end
	test "Should_visit_FAQ2" do
		within('div#faqBlock.row') do
			click_on(text: 'FAQ')
		end
		assert_text('accessing my mic or webcam')
	end
	test "Should_visit_FAQ3" do
		within('div.col-sm-2.col-sm-offset-1') do
			click_on(text: 'FAQ')
		end
		assert_text('accessing my mic or webcam')
	end
	test "Should say name can't be blank when nothing is in sign up parameters" do
		click_on('Sign out')
		click_on('Sign Up', match: :first)
        fill_in(id:'user_name', with: '')
        fill_in(id:'user_email', with: '')
        fill_in(id:'user_permalink', with:'')
        fill_in(id:'user_password', with: '', :match => :prefer_exact)
        fill_in(id:'user_password_confirmation', with:'')
        click_on(class: 'form-control btn-primary')
        assert_text('Name can\'t be blank')
	end
	test "Should say email can't be blank when nothing is in sign up parameters" do
		click_on('Sign out')
		click_on('Sign Up', match: :first)
        fill_in(id:'user_name', with: '')
        fill_in(id:'user_email', with: '')
        fill_in(id:'user_permalink', with:'')
        fill_in(id:'user_password', with: '', :match => :prefer_exact)
        fill_in(id:'user_password_confirmation', with:'')
        click_on(class: 'form-control btn-primary')
        assert_text('Email can\'t be blank')
	end
	test "Should say permalink can't be blank when nothing is in sign up parameters" do
		click_on('Sign out')
		click_on('Sign Up', match: :first)
        fill_in(id:'user_name', with: '')
        fill_in(id:'user_email', with: '')
        fill_in(id:'user_permalink', with:'')
        fill_in(id:'user_password', with: '', :match => :prefer_exact)
        fill_in(id:'user_password_confirmation', with:'')
        click_on(class: 'form-control btn-primary')
        assert_text('Permalink can\'t be blank')
	end
	test "Should say password can't be blank when nothing is in sign up parameters" do
		click_on('Sign out')
		click_on('Sign Up', match: :first)
        fill_in(id:'user_name', with: '')
        fill_in(id:'user_email', with: '')
        fill_in(id:'user_permalink', with:'')
        fill_in(id:'user_password', with: '', :match => :prefer_exact)
        fill_in(id:'user_password_confirmation', with:'')
        click_on(class: 'form-control btn-primary')
        assert_text('Password can\'t be blank')
	end
	test "Should not sign up with non alphanumeric characters" do
		click_on('Sign out')
		click_on('Sign Up', match: :first)
        fill_in(id:'user_name', with: 'user')
        fill_in(id:'user_email', with: 'user@user.com')
        fill_in(id:'user_permalink', with:'`~!@#$%^&*()_-=+*/<>')
        fill_in(id:'user_password', with: 'password', :match => :prefer_exact)
        fill_in(id:'user_password_confirmation', with:'password')
        click_on(class: 'form-control btn-primary')
        assert_text('Permalink is invalid')
	end
    test "Should not show sales when not signed into stripe" do
        click_on('Sign out')
        click_on('Sign Up', match: :first)
        fill_in(id:'user_name', with: 'name')
        fill_in(id:'user_email', with: 'e@gmail.com')
        fill_in(id:'user_permalink', with:'username')
        fill_in(id:'user_password', with: 'password', :match => :prefer_exact)
        fill_in(id:'user_password_confirmation', with:'password')
        click_on(class: 'form-control btn-primary')
        visit ('/')
        click_on(text: 'name',:match => :first)
        click_on(text: 'Control Panel')
        click_on(text:'Sales')
        assert_text('Sales figures will be displayed on this page after you connect to Stripe.')
    end
    test 'Should show username in controlpanel' do
        click_on(text: 'Phineas',:match => :first)
        click_on(text: 'View Profile')
        assert_text('Phineas')
    end
    test 'Should show name field in signup' do
        click_on('Sign out')
        click_on('Sign Up', match: :first)
        assert page.has_field?('user_name')
    end
    test 'Should show email field in signup' do
        click_on('Sign out')
        click_on('Sign Up', match: :first)
        assert page.has_field?('user_email')
    end
    test 'Should show username field in signup' do
        click_on('Sign out')
        click_on('Sign Up', match: :first)
        assert page.has_field?('user_permalink')
    end
    test 'Should show enter password field in signup' do
        click_on('Sign out')
        click_on('Sign Up', match: :first)
        assert page.has_field?('user_password')
    end
    test 'Should show confirm password field in signup' do
        click_on('Sign out')
        click_on('Sign Up', match: :first)
        assert page.has_field?('user_password_confirmation')
    end
    test 'Should show email field in signin' do
        click_on('Sign out')
        click_on('Sign In', match: :first)
        assert page.has_field?('user_email')
    end
    test 'Should show password field in signin' do
        click_on('Sign out')
        click_on('Sign In', match: :first)
        assert page.has_field?('user_password')
    end
    test 'Should show title of livestream show field when posting a new show' do
        click_on('Host a Livestream Discussion')
        assert page.has_field?('event_name')
    end
    test 'Should show start date field when posting a new show' do
        click_on('Host a Livestream Discussion')
        assert page.has_field?('event_start_at')
    end
    test 'Should show start year field when posting a new show' do
        click_on('Host a Livestream Discussion')
        assert page.has_field?('event_start_at_1i')
    end
    test 'Should show start month field when posting a new show' do
        click_on('Host a Livestream Discussion')
        assert page.has_field?('event_start_at_2i')
    end
    test 'Should show start day field when posting a new show' do
        click_on('Host a Livestream Discussion')
        assert page.has_field?('event_start_at_3i')
    end
    test 'Should show start hour field when posting a new show' do
        click_on('Host a Livestream Discussion')
        assert page.has_field?('event_start_at_4i')
    end
    test 'Should show start minute field when posting a new show' do
        click_on('Host a Livestream Discussion')
        assert page.has_field?('event_start_at_5i')
    end
    test 'Should show end year field when posting a new show' do
        click_on('Host a Livestream Discussion')
        assert page.has_field?('event_end_at_1i')
    end
    test 'Should show end month field when posting a new show' do
        click_on('Host a Livestream Discussion')
        assert page.has_field?('event_end_at_2i')
    end
    test 'Should show end day field when posting a new show' do
        click_on('Host a Livestream Discussion')
        assert page.has_field?('event_end_at_3i')
    end
    test 'Should show end hour field when posting a new show' do
        click_on('Host a Livestream Discussion')
        assert page.has_field?('event_end_at_4i')
    end
    test 'Should show end minute field when posting a new show' do
        click_on('Host a Livestream Discussion')
        assert page.has_field?('event_end_at_5i')
    end
    test 'Should show show description field when posting a new show' do
        click_on('Host a Livestream Discussion')
        assert page.has_field?('event_desc')
    end
    test 'Should show name field when editing profile' do
        click_on(text: 'Phineas',:match => :first)
        click_on(text: 'Control Panel')
        assert page.has_field?('user_name')
    end
    test 'Should show profilepic field when editing profile' do
        click_on(text: 'Phineas',:match => :first)
        click_on(text: 'Control Panel')
        assert page.has_field?('user_profilepic')
    end
    test 'Should show about you field when editing profile' do
        click_on(text: 'Phineas',:match => :first)
        click_on(text: 'Control Panel')
        assert page.has_field?('user_about')
    end
    test 'Should show category field when editing profile' do
        click_on(text: 'Phineas',:match => :first)
        click_on(text: 'Control Panel')
        assert page.has_field?('user_genre1')
    end
    test 'Should show subcategory field when editing profile' do
        click_on(text: 'Phineas',:match => :first)
        click_on(text: 'Control Panel')
        assert page.has_field?('user_genre2')
    end
    test 'Should show another subcategory field when editing profile' do
        click_on(text: 'Phineas',:match => :first)
        click_on(text: 'Control Panel')
        assert page.has_field?('user_genre3')
    end
    test 'Should show bannerpic field when editing profile' do
        click_on(text: 'Phineas',:match => :first)
        click_on(text: 'Control Panel')
        assert page.has_field?('user_bannerpic')
    end
    test 'Should show twitterhandle field when editing profile' do
        click_on(text: 'Phineas',:match => :first)
        click_on(text: 'Control Panel')
        assert page.has_field?('user_twitter')
    end
    test 'Should show first youtube project field when editing profile' do
        click_on(text: 'Phineas',:match => :first)
        click_on(text: 'Control Panel')
        assert page.has_field?('user_youtube1')
    end
    test 'Should show second youtube project field when editing profile' do
        click_on(text: 'Phineas',:match => :first)
        click_on(text: 'Control Panel')
        assert page.has_field?('user_youtube2')
    end
    test 'Should show third youtube project field when editing profile' do
        click_on(text: 'Phineas',:match => :first)
        click_on(text: 'Control Panel')
        assert page.has_field?('user_youtube3')
    end
    test 'Should show email field when editing account' do
        click_on(text: 'Phineas',:match => :first)
        click_on(text: 'Control Panel')
        click_on(text: 'Account')
        assert page.has_field?('user_email')
    end
    test 'Should show custom URL field when editing account' do
        click_on(text: 'Phineas',:match => :first)
        click_on(text: 'Control Panel')
        click_on(text: 'Account')
        assert page.has_field?('user_permalink')
    end
    test 'Should render livestream directions from controlpanel' do
        click_on(text: 'Phineas',:match => :first)
        click_on(text: 'Control Panel')
        click_on(text: 'Shows')
        assert_text('Pre-Show Checklist')
    end
end
