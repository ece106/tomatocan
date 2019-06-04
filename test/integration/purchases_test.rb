require 'test_helper'
require 'capybara-screenshot/minitest'
require 'capybara/apparition'
#require 'selenium-webdriver'
#options = Selenium::WebDriver::Firefox::Options.new(args: ['-headless']) don't use this
#@driver = Selenium::WebDriver.for :firefox
#@driver.navigate.to 'http://localhost:3000/'
class UsersTest < ActionDispatch::IntegrationTest

  setup do
    @purchases = purchases(:one)
    @purchaser = users(:two) #user 2 is the customer 
    @seller = users(:one)
  end

    include Capybara::DSL
    include Capybara::Minitest::Assertions
    Capybara::Screenshot.autosave_on_failure = false
    setup do
    visit ('http://localhost:3000/')
        
        def signInPurchaser()
            visit ('http://localhost:3000/')
            click_on('Sign In', match: :first)
            fill_in(id:'user_email', with: @purchaser.email)
            fill_in(id:'user_password', with: @purchaser.encrypted_password)
            puts("pwd  " + @purchaser.encrypted_password)
            click_on(class: 'form-control btn-primary')
        end
        
        @time=Time.now
    end

    test 'Should_buy_from_user' do
        visit('http://localhost:3000/')
        cardToken = Stripe::Token.create({
          card: {
            number: "4242424242424242",
            exp_month: 8,
            exp_year: 2060,
            cvc: "123"
          }
        })
        customer = Stripe::Customer.create(
                                          :description => @purchaser.name,
                                          :email => @purchaser.email
                                          )
        customer.save
        @purchaser.update_column(:stripe_customer_token, customer.id)

        puts (@purchaser.stripe_customer_token)

        signInPurchaser()
        puts("signed in")
        click_on('Discover Talk Show Hosts')
        click_link(@seller.name)
        puts(@seller.name + " seller name")
        click_on('Buy for $1.50')
        puts ("clicked")
        
        fill_in(id:'card_number', with:'4242424242424242')
        select("2020", from: 'card_year')
        click_on('Purchase')
        assert_text('successfully')
    end

  end