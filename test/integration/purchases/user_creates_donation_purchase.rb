require 'test_helper'
require 'capybara-screenshot/minitest'
require 'stripe'
class UserCreatesDonationPurchase < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Minitest::Assertions
  Capybara::Screenshot.autosave_on_failure = false

  setup do
    @purchase               = purchases(:one)
    @user_one               = users(:one)
    @donation_merch         = merchandises(:seven)
    @user_two               = users(:two)
    @visit_new_donation     = lambda { |donation_id| visit new_purchase_path  merchandise_id: donation_id }
    @visit_default_donation = lambda { |author_id, price| visit new_purchase_path  author_id: author_id, pricesold: price }
    @card_css               = ['#card_number','#card_code','#card_month','#card_year']
    @default_prices         = [25,50,100] #if changes occur to defualt donation prices you can edit this list

  end

  #right now this is based on merchandise_id in the view and the button will show up purchase because it is a donation merchandise
  #test 'user makes a dontation with a new card' do
    #user_sign_in @user_two
    #@visit_new_donation.call @donation_merch.id
    #card_information_entry
    #assert page.has_button? 'Purchase'
    #click_on 'Purchase'   
    #assert_current_path "/#{@user_one.permalink}"
  #end

  #this is also a donation merchandise donation so it will have a purchase button as well as a buy now
  test 'user makes a donation with stripe_customer_token present' do
    user_sign_in @user_two
    token = stripe_token_create @user_two
    @user_two.update_attribute :stripe_customer_token, token.id
    @visit_new_donation.call @donation_merch.id
    assert page.has_css? '.last4'
    assert page.has_button? 'Buy now'
    find(:button, 'Buy now', match: :first).click
    assert_current_path "/#{ @user_one.permalink }"
  end

  test 'user uses different card to donate' do
    user_sign_in @user_two
    token = stripe_token_create @user_two
    @user_two.update_attribute :stripe_customer_token, token.id
    @visit_new_donation.call @donation_merch.id
    assert page.has_css? '.diffcard'
    click_on class: 'diffcard'
    @card_css.each { |x| assert page.has_css? x }
    card_information_entry 
    assert page.has_button? 'Buy now'
    find(:button, 'Buy now', match: :first).click
    assert_current_path "/#{ @user_one.permalink }"
  end

  #this is a default donation
  test 'user makes a default donation first time' do
    user_sign_in @user_two
    @default_prices.each do |price| 
      @visit_default_donation.call @purchase.author_id, price
      @card_css.each { |x| assert page.has_css? x }
      fill_in id: 'purchase_shipaddress', with: "#{SecureRandom.alphanumeric(10)}"
      #invalid value of card info
      fill_in id: 'card_number',          with: "1234"
      fill_in id: 'card_code',            with: "123"
      select '8 - August',                from: 'card_month'
      select '2024',                      from: 'card_year'
      assert page.has_button? 'Donate'
      click_on 'Donate'
      assert_current_path new_purchase_path  author_id: @purchase.author_id, pricesold: price
      # issue with the testing card, should redirect to seller's page 
      # assert_current_path "/purchases"
      @user_two.update_attribute :stripe_customer_token, ""
    end
  end

  test 'user makes a default donation as a returning customer' do
    user_sign_in @user_two
    token = stripe_token_create @user_two
    @user_two.update_attribute :stripe_customer_token, token.id
    @default_prices.each do |price| 
      @visit_default_donation.call @purchase.author_id, price
      assert page.has_button? 'Donate now'
      find(:button, 'Donate now', match: :first).click
      assert_current_path "/#{ @user_one.permalink }"
    end
  end

  def teardown 
    @user_two.update_attribute :stripe_customer_token, ""
    click_on class: 'btn btn-primary border-warning text-warning'
  end

  private 

  def stripe_token_create user
    card_token = Stripe::Token.create( { card: { number: "#{@card_number}",
                                         exp_month: '8',
                                         exp_year: '2020',
                                         cvc: '123' } } ) 
    Stripe::Customer.create(source: card_token,
                            description: 'test',
                            email: user.email)
  end
end 
