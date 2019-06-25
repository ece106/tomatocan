require 'test_helper'
require 'capybara-screenshot/minitest'
#require 'capybara/apparition'
require 'stripe'
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

  def signUpPurchaser()
      visit ('http://localhost:3000/')
      click_on('Sign Up', match: :first)
      fill_in(id:'user_name', with: 'purchaser')
      fill_in(id:'user_email', with: 'pur@gmail.com')
      fill_in(id:'user_permalink', with:'purchaser')
      fill_in(id:'user_password', with: 'password', :match => :prefer_exact)
      fill_in(id:'user_password_confirmation', with:'password')
      click_on(class: 'form-control btn-primary')
      click_on('Sign out')
  end
  def signInPurchaser()
      visit ('http://localhost:3000/')
      click_on('Sign In', match: :first)
      fill_in(id:'user_email', with: 'pur@gmail.com')
      fill_in(id:'user_password', with: 'password')
      click_on(class: 'form-control btn-primary')
  end

  def signUpFixture()
    visit ('http://localhost:3000/')
    click_on('Sign Up', match: :first)
    fill_in(id:'user_name', with: @purchaser.name)
    fill_in(id:'user_email', with: @purchaser.email)
    fill_in(id:'user_permalink', with: @purchaser.permalink)
    fill_in(id:'user_password', with: "user1234" , :match => :prefer_exact)
    fill_in(id:'user_password_confirmation', with:"user1234")
    click_on(class: 'form-control btn-primary')
    #click_on('Sign out')
end
def signInFixture()
    visit ('http://localhost:3000/')
    click_on('Sign In', match: :first)
    fill_in(id:'user_email', with: @purchaser.email)
    fill_in(id:'user_password', with: "user1234")
    click_on(class: 'form-control btn-primary')
end
        
        @time=Time.now
    end

    test 'Should_buy_from_user_error' do #card source not present
        signUpPurchaser() #signing up a new user

        cardToken = Stripe::Token.create({  #create Stripe account for new user
          card: {
            number: "4242424242424242",
            exp_month: 1,
            exp_year: 2023,
            cvc: "123"
          }
        })
        customer = Stripe::Customer.create(
                                          :source => cardToken,
                                          :description => 'purchaser',
                                          :email => 'pur@gmail.com'
                                          )
        customer.save

        signInPurchaser()
        click_on('Discover Previous Discussions')
        click_link(@seller.name)
        puts(@seller.name + " seller name")
        click_on('Buy for $1.50!')
        puts ("clicked")
        #fill_in(id:'purchase_email', with:'pur@gmail.com')
        fill_in(id:'card_number', with:'4242424242424242')
        fill_in(id:'card_code', with:'123')
        #select('1 - January', from: 'card_month')
        select('2023', from: 'card_year')
        click_on('Purchase')

        assert_text 'Your order did not go through. Try again.'
    end

    test 'signing up a fixture' do
      puts @purchaser.encrypted_password
      signUpFixture()
      assert_text('Email has already been taken')
    end

    test "purchase_merchandise_by_a_fixture_whose_card_is_registered_with_stripe" do
        
      cardToken = Stripe::Token.create({
        card: {
          number: "4242424242424242",
          exp_month: 8,
          exp_year: 2060,
          cvc: "123"
        }
      })
      customer = Stripe::Customer.create( 
                                        :source => cardToken,
                                        :description => @purchaser.name,
                                        :email => @purchaser.email
                                        )
      customer.save
      @purchaser.update_column(:stripe_customer_token, customer.id)
      puts (@purchaser.stripe_customer_token)
      
      signInFixture()
      puts("signed in")
      click_on('Discover Previous Discussions')
      click_link(@seller.name)
      puts(@seller.name + " seller name")
      click_on('Buy for $1.50')
      puts ("clicked")
      within '.buyexistingcard' do
        click_button('Buy now')
      end

      assert_text 'You have successfully completed the purchase!'
    end

    test "to_purchase_donation_by_a_fixture_whose_card_is_registered_with_stripe" do
          
      cardToken = Stripe::Token.create({
        card: {
          number: "4242424242424242",
          exp_month: 8,
          exp_year: 2060,
          cvc: "123"
        }
      })
      customer = Stripe::Customer.create( 
                                        :source => cardToken,
                                        :description => @purchaser.name,
                                        :email => @purchaser.email
                                        )
      customer.save
      @purchaser.update_column(:stripe_customer_token, customer.id)
      puts (@purchaser.stripe_customer_token)
      
      signInFixture()
      puts("signed in")
      click_on('Discover Previous Discussions')
      click_link(@seller.name)
      puts(@seller.name + " seller name")
      click_on('Donate $2.00!', match: :first)
      puts ("clicked")
      within '.buyexistingcard' do
        click_button('Buy now')
      end

      assert_text 'You have successfully completed the purchase!'
    end

    test "to_purchase_donation_by_a_fixture_whose_card_is_not_registered_with_stripe" 
        signInFixture()
        puts("signed in")
        click_on('Discover Previous Discussions')
        click_link(@seller.name)
        puts(@seller.name + " seller name")
        click_on('Donate $2.00!', match: :first)
        puts ("clicked")

        fill_in(id:'card_number', with:'4242424242424242')
        fill_in(id:'card_code', with:'123')
        #select('1 - January', from: 'card_month')
        select('2023', from: 'card_year')
        click_on('Purchase')
        assert_text 'You have successfully completed the purchase!'
    end

end