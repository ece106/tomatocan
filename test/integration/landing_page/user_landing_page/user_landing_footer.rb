require 'test_helper'
require 'capybara-screenshot/minitest'

class UserLandingFooter < ActionDispatch::IntegrationTest
	setup do
		@user = users :one

    sign_in

    visit root_path
	end
	
	test 'information and mail links' do
		assert page.has_css? 'f-link'
		click_on class: 'f-link'
		
		about_link = find('link=About')
		faq_link = find('link=FAQ')
		tos_link = find('link=Terms of Service')
		mail_link = find("//a[@href='mailto:info@thinq.tv' and @alt='Email']")
		
		assert page.has_xpath? about_link
		assert page.has_xpath? faq_link
		assert page.has_xpath? tos_link
		assert page.has_xpath? mail_link
	end
	
	test 'share site with others' do
		assert page.has_css? 'social-share-button'
		
		click_on class: 'social-share-button'
		
		facebook_img = "//a[@href = 'https://www.facebook.com/sharer/sharer.php?u=http%3A%2F%2Fwww.thinq.tv%2F&amp;src=sdkpreparse']"
		twitter_img = "//a[@href = 'https://twitter.com/intent/tweet?hashtags=ThinQTV&text=Broadcast%20live%20discussions%20about%20what%20you%27re%20doing%20to%20change%20the%20world%20and%20participate%20in%20intellectual%20discussions%20to%20broaden%20your%20knowledge!&tw_p=tweetbutton&url=http%3A%2F%2Fwww.ThinQ.tv%2F']"
		linkedin_img = "//a[@href = 'https://www.linkedin.com/shareArticle?mini=true&url=']"
		email_img = "//a[@href = 'mailto:?subject=Check out this site called ThinQTV!&amp;body=You are invited to check out <%= url %>!%0D%0A%0D%0A<%= desc %>%0D%0A%0D%0AThe schedule is: Tuesdays 6:30pm PDT / 9:30pm EDT - Tech Tuesday%0D%0AWednesdays 6:30pm PDT / 9:30pm EDT - Conversations on Faith%0D%0AThursdays 7:30pm PDT / 10:30pm EDT - International Awareness%0D%0A%0D%0AStay tuned for more weekly topics on Books, Innovation, and Environmental issues.%0D%0A%0D%0A%0D%0A%0D%0A']"
		
		assert page.has_xpath? facebook_img
		assert page.has_xpath? twitter_img
		assert page.has_xpath? linkedin_img
		assert page.has_xpath? email_img
	end
	
	def sign_in
    visit root_path users

    click_on 'Sign In', match: :first

    fill_in id: 'user_email', with: "#{@user.email}"
    fill_in id: 'user_password', with: "#{@user.password}"

    click_on class: 'form-control btn-primary'
  end
end
