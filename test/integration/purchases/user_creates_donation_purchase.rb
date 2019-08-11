require 'test_helper'
require 'capybara-screenshot/minitest'
require 'stripe'
class UserCreatesDonationPurchase < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Minitest::Assertions
  Capybara::Screenshot.autosave_on_failure = false

  setup do
    @purchase = purchases(:one)
    @user_one = users(:one) 
    @donation_merch = merchandises(:seven)
    @user_two = users(:two)
    @card_number = "4242424242424242" 
    @cvc = "123"

  end

  test 'user makes a dontation with a new card' do
    user_sign_in @user_two
    visit "/#{@user_one.permalink}"
    first(:link, "#{@donation_merch.buttontype} $#{@donation_merch.price}0!").click
    card_information_entry
    binding.pry
    click_on 'Purchase'   

    assert_equal "/#{@user_one.permalink}", current_path
  end
  
  test 'user makes a donation with stripe_customer_token present' do
    user_sign_in @user_two
    token = stripe_token_create @user_two
    @user_two.update_attribute :stripe_customer_token, token.id
    visit "/#{@user_one.permalink}"
    first(:link, "#{@donation_merch.buttontype} $#{@donation_merch.price}0!").click

    assert page.has_css? '.last4'

    click_on 'Buy now'

    assert_equal "/#{@user_one.permalink}", current_path
  end

  private 
  
  def user_sign_in  user
    visit root_path 
    click_on 'Sign In' 
    fill_in id: 'user_email', with: "#{user.email}"
    fill_in id: 'user_password', with: "#{user.password}"
    click_on class: 'form-control btn-primary'
  end

  def card_information_entry 
    fill_in id: 'card_number', with: "#{@card_number}"
    fill_in id: 'card_code', with: "#{@cvc}"
    select 'August', from: 'card_month'
    select '2024', from: 'card_year'
  end 

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
