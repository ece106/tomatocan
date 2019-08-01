class Purchase < ApplicationRecord
  require 'payment_gateway'

  belongs_to :user, optional: true
  belongs_to :merchandise, optional: true

  validates :author_id, presence: true # author means seller
  validates :pricesold, presence: true
  validates :authorcut, presence: true

  def save_payment_with_merchandise
    setup_payment_information

    if is_purchase_anonymous?
      process_anonymous_payment_with_merchandise
    else
      process_user_payment_with_merchandise
    end

    begin
      save!
    rescue Stripe::InvalidRequestError => e
    end
  end

  def save_payment_with_donation
    setup_payment_information

    if is_purchase_anonymous?
      process_anonymous_donation
    else
      process_user_donation
    end

    begin
      save!
    rescue Stripe::InvalidRequestError => e
    end
  end

  def setup_payment_information
    @merchandise = Merchandise.find(self.merchandise_id)
    self.update_attribute(:pricesold, @merchandise.price)

    @seller                = User.find(@merchandise.user_id)
    @seller_stripe_account = retrieve_seller_stripe_account(@seller)
    self.author_id         = @seller.id
    self.authorcut         = calculate_authorcut
    @amount                = calculate_amount
    @application_fee       = calculate_application_fee @amount
  end

  def process_anonymous_payment_with_merchandise
    charge_params = {
      amount: @amount,
      currency: 'usd',
      source: self.stripe_card_token,
      description: @merchandise.desc,
      application_fee: @application_fee
    }
    charge_opts_params = { stripe_account: @seller_stripe_account.id }
    PaymentGateway.create_charge(charge_params, charge_opts_params)
  end

  def process_user_payment_with_merchandise
    @buyer = User.find(self.user_id)

    if @buyer.stripe_customer_token.present?
      @returning_customer = Stripe::Customer.retrieve(@buyer.stripe_customer_token)
      token_params        = { customer: @returning_customer.id }
      token_opts_params   = { stripe_account: @seller_stripe_account.id }
      @token              = PaymentGateway.create_token(token_params, token_opts_params)

      charge_params = {
        amount: @amount,
        currency: 'usd',
        source: @token.id,
        description: @merchandise.desc,
        application_fee: @application_fee
      }
      charge_opts_params = { stripe_account: @seller_stripe_account.id }

      PaymentGateway.create_charge(charge_params, charge_opts_params)
    else
      customer_params = {
        source: self.stripe_card_token,
        description: @merchandise.desc,
        email: self.email
      }
      @customer = PaymentGateway.create_customer(customer_params)
      # @buyer.update_attribute(:stripe_customer_token, @customer.id)
      @buyer.stripe_customer_token = @customer.id
      token_params      = { customer: @customer.id }
      token_opts_params = { stripe_account: @seller_stripe_account.id }
      @token            = PaymentGateway.create_token(token_params, token_opts_params)

      charge_params = {
        amount: @amount,
        currency: "usd",
        source: @token.id,
        description: @merchandise.desc,
        application_fee: @application_fee
      }
      charge_opts_params = { stripe_account: @seller_stripe_account.id }
      PaymentGateway.create_charge(charge_params, charge_opts_params)
    end
  end

  def process_anonymous_donation
    charge_params = {
      amount: @amount,
      currency: 'usd',
      source: self.stripe_card_token,
      description: @merchandise.desc,
      application_fee: @application_fee
    }
    charge_opts_params = { stripe_account: @seller_stripe_account.id }

    PaymentGateway.create_charge(charge_params, charge_opts_params)
  end

  def process_user_donation
    @donator = User.find(self.user_id)

    if @donator.stripe_customer_token.present?
      @returning_customer = Stripe::Customer.retrieve(@donator.stripe_customer_token)
      token_params        = { customer: @returning_customer.id }
      token_opts_params   = { stripe_account: @seller_stripe_account.id }
      @token              = PaymentGateway.create_token(token_params, token_opts_params)

      charge_params = {
        amount: @amount,
        currency: 'usd',
        source: @token.id,
        description: @merchandise.desc,
        application_fee: @application_fee
      }
      charge_opts_params = {
        stripe_account: @seller_stripe_account.id
      }

      PaymentGateway.create_charge(charge_params, charge_opts_params)
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

      token_params = { customer: @customer.id }
      token_opts_params = { stripe_account: @seller_stripe_account.id }
      @token = PaymentGateway.create_token(token_params, token_opts_params)

      charge_params = {
        amount: @amount,
        currency: "usd",
        source: @token.id,
        description: @merchandise.desc,
        application_fee: @application_fee
      }
      charge_opts_params = { stripe_account: @seller_stripe_account.id }
      PaymentGateway.create_charge(charge_params, charge_opts_params)
    end
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
