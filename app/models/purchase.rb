class Purchase < ApplicationRecord
  require 'payment_gateway'

  belongs_to :user, optional: true
  belongs_to :merchandise, optional: true

  validates :author_id, presence: true # author means seller
  validates :pricesold, presence: true
  validates :authorcut, presence: true

  attr_accessor :amount, :application_fee, :seller, :seller_stripe_account, :token

  CURRENCY = 'usd'

  def save_with_payment
    begin
      setup_payment_information
      is_merchandise_buy_or_donate? ? save_payment_with_merchandise : save_payment_with_donation
      save!
    rescue Stripe::InvalidRequestError => e
    end
  end

  def save_payment_with_merchandise
    is_purchase_anonymous? ? anonymous_merchandise_payment : user_merchandise_payment
  end

  def save_payment_with_donation
    is_purchase_anonymous? ? anonymous_donation : user_donation
  end

  #- Setup payment information
  def setup_payment_information
    # self.update_attribute(:pricesold, @merchandise.price)
    @merchandise               = Merchandise.find(self.merchandise_id)
    self.pricesold             = @merchandise.price
    self.seller                = User.find(@merchandise.user_id)
    self.seller_stripe_account = retrieve_seller_stripe_account(seller)
    self.author_id             = seller.id
    self.authorcut             = calculate_authorcut
    self.amount                = calculate_amount
    self.application_fee       = calculate_application_fee self.amount
  end

  def anonymous_merchandise_payment
    PaymentGateway.create_anonymous_charge(self, CURRENCY, @merchandise)
  end

  def user_merchandise_payment
    @buyer = User.find(self.user_id)

    if @buyer.stripe_customer_token.present?
      @returning_customer = Stripe::Customer.retrieve(@buyer.stripe_customer_token)
      self.token          = PaymentGateway.create_token(self, @returning_customer)
      PaymentGateway.create_charge(self, CURRENCY, @merchandise)
    else
      customer_params = {
        source: self.stripe_card_token,
        description: @merchandise.desc,
        email: self.email
      }
      @customer = PaymentGateway.create_customer(customer_params)
      # @buyer.update_attribute(:stripe_customer_token, @customer.id)
      @buyer.stripe_customer_token = @customer.id
      token_params                 = { customer: @customer.id }
      token_opts_params            = { stripe_account: self.seller_stripe_account.id }
      self.token                   = PaymentGateway.create_token(token_params, token_opts_params)

      PaymentGateway.create_charge(self, CURRENCY, @merchandise)
    end
  end

  def anonymous_donation
    PaymentGateway.create_anonymous_charge(self, CURRENCY, @merchandise)
  end

  def user_donation
    @donator = User.find(self.user_id)

    if @donator.stripe_customer_token.present?
      @returning_customer = Stripe::Customer.retrieve(@donator.stripe_customer_token)
      token_params        = { customer: @returning_customer.id }
      token_opts_params   = { stripe_account: self.seller_stripe_account.id }
      self.token          = PaymentGateway.create_token(token_params, token_opts_params)

      PaymentGateway.create_charge(self, CURRENCY, @merchandise)
      # PaymentGateway.create_charge(charge_params, charge_opts_params)
      # @returning_donator.source = self.stripe_card_token
      # @returning_donator.save
    else
      customer_params =  {
        source: self.stripe_card_token,
        description: @merchandise.desc,
        email: self.email
      }
      @customer = PaymentGateway.create_customer(customer_params)
      @donator.update_attribute(:stripe_customer_token, @customer.id)

      token_params      = { customer: @customer.id }
      token_opts_params = { stripe_account: self.seller_stripe_account.id }
      self.token        = PaymentGateway.create_token(token_params, token_opts_params)

      PaymentGateway.create_charge(self, CURRENCY, @merchandise)
    end
  end

  # ===============================================

  def is_merchandise_buy_or_donate?
    @merchandise.buttontype == 'Buy' ? true : false
  end

  def is_returning_customer?
    self.stripe_customer_token.present? ? true : false
  end

  def retrieve_seller
    merchandise = Merchandise.find(self.merchandise_id)
    seller      = merchandise.user_id
  end

  def retrieve_customer_card(current_user)
    customer = Stripe::Customer.retrieve(current_user.stripe_customer_token)
    sourceid = customer.default_source
    card     = customer.sources.retrieve(sourceid)
    card
  end

  private

  def is_purchase_anonymous?
    self.email.present? ? true : false
  end

  def retrieve_seller_stripe_account(seller)
    Stripe::Account.retrieve(seller.stripeid)
  end

  def calculate_amount
    (self.pricesold * 100).to_i
  end

  def calculate_authorcut
    ((self.pricesold * 92.1).to_i - 30).to_f/100
  end

  def calculate_application_fee amount
    ((amount * 5)/100)
  end

end
