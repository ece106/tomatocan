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

    test "signing up a fixture" do
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
      signInFixture()
      click_on('Discover Previous Discussions')
      click_link(@seller.name)
      puts(@seller.name + " seller name")
      click_on('Donate $2.00!', match: :first)
      within '.buyexistingcard' do
        click_button('Buy now')
      end

      assert_text 'You have successfully completed the purchase!'
    end

    test "to_purchase_merchandise_without_a_payment_method" do
        puts "test 1"
        signInFixture()
        click_on('Discover Previous Discussions')
        click_link(@seller.name)
        click_on('Buy for $1.50')
        click_on('Purchase')
        assert_text 'Your order did not go through. Try again.'
    end

    # Will finish the test below after setting up receipts for purchases
    # test "to_purchase_a_merchandise_with_card" do #card source not present in stripe dashboard
    #   puts "test 2"
    #   signInFixture()
    #   click_on('Discover Previous Discussions')
    #   click_link(@seller.name)
    #   click_on('Buy for $1.50!')
    #   page.fill_in 'card_number', with:"4242424242424242"
    #   page.fill_in 'card_code', with:"123"
    #   select('2023', from: 'card_year')
    #   select('1 - January', from: 'card_month')
    #   click_on('Purchase')
    #   assert_text 'You have successfully completed the purchase!'
    #   #Failure due to stripe error, source not present? "JavaScript is not enabled and is required for this form. First enable it in your web browser settings."
    # end

end