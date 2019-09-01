require 'test_helper'
require 'capybara-screenshot/minitest'
require 'stripe'
class UserCreatesDonationPurchase < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Minitest::Assertions
  Capybara::Screenshot.autosave_on_failure = false

  setup do
    @purchase              = purchases(:one)
    @user_one              = users(:one)
    @donation_merch        = merchandises(:seven)
    @user_two              = users(:two)
    @visit_new_donation    = lambda { |donation_id| visit new_purchase_path  merchandise_id: donation_id }
    @visit_deault_donation = lambda { |price, author_id| visit new_purchase_path  author_id: author_id, pricesold: price }
    @card_css              = ['#card_number','#card_code','#card_month','#card_year']
  end

  test 'user makes a dontation with a new card' do
    user_sign_in @user_two
    @visit_new_donation.call @donation_merch.id
    card_information_entry
    assert page.has_button? 'Donate'
    click_on 'purchase-btn'   
    assert_current_path "/#{@user_one.permalink}"
  end
  
  test 'user makes a donation with stripe_customer_token present' do
    user_sign_in @user_two
    binding.pry
    token = stripe_token_create @user_two
    @user_two.update_attribute :stripe_customer_token, token.id
    @visit_new_donation.call @donation_merch.id
    binding.pry
    assert page.has_css? '.last4'
    assert page.has_button? 'Donate now'

  end

  test 'user uses different card to donate' do
    user_sign_in @user_two
    token = stripe_token_create @user_two
    @user_two.update_attribute :stripe_customer_token, token.id
    @visit_new_donation.call @donation_merch.id
    binding.pry
    assert page.has_css? '.diffcard'
    find(:link, 'diffcard', match: :first).click
    @card_css.each { |x| assert page.has_css? x }
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
