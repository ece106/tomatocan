class Purchase < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :merchandise, optional: true

  validates :author_id, presence: true # author means seller
  validates :pricesold, presence: true
  validates :authorcut, presence: true

  include PaymentGateway

  attr_accessor :card_number, :card_code, :amount, :application_fee_amount, :seller,
    :seller_stripe_account, :token, :currency

  CURRENCY = 'usd'.freeze

  def save_with_payment
    begin
      # Check for a defaut donation
      if self.merchandise_id.nil?
        setup_default_donation
        is_anonymous? ? anonymous_charge : user_donation
      else
        setup_payment_information
        merchandise_buy_or_donate? ? merchandise_payment : donation_payment
      end

      save!
    rescue Stripe::InvalidRequestError => e
    end
  end

  def merchandise_payment
    is_anonymous? ? anonymous_charge : user_merchandise_payment
  end

  def donation_payment
    is_anonymous? ? anonymous_charge : user_donation
  end

  def anonymous_charge
    PaymentGateway.create_anonymous_charge(self)
  end

  def setup_default_donation
    self.seller                = User.find(self.author_id)
    self.seller_stripe_account = PaymentGateway.retrieve_seller_account(self.seller.stripeid)
    # self.author_id             = self.seller.id
    self.authorcut             = calculate_authorcut(self.pricesold)
    self.amount                = calculate_amount(self.pricesold)
    self.application_fee_amount = calculate_application_fee_amount(self.amount)
    self.currency              = CURRENCY
  end

  def setup_payment_information
    # self.update_attribute(:pricesold, @merchandise.price)
    # self.seller_stripe_account = retrieve_seller_stripe_account(seller)
    @merchandise               = Merchandise.find(self.merchandise_id)
    self.pricesold             = @merchandise.price
    self.seller                = User.find(@merchandise.user_id)
    self.seller_stripe_account = PaymentGateway.retrieve_seller_account(seller.stripeid)
    self.author_id             = seller.id
    self.authorcut             = calculate_authorcut(self.pricesold)
    self.amount                = calculate_amount(self.pricesold)
    self.application_fee_amount       = calculate_application_fee_amount(self.amount)
    self.currency              = CURRENCY
  end

  # Checks if the user is anonymous or returning buyer.
  def user_merchandise_payment
    buyer = User.find(self.user_id)

    buyer.stripe_customer_token.present? ? returning_customer(buyer) : first_time_buyer(buyer)
  end

  # Checks if the user is anonymous or returning donator.
  def user_donation
    donator = User.find(self.user_id)
    donator.stripe_customer_token.present? ? returning_donator(donator) : first_time_donator(donator)
  end

  # Creates the stripe charge object for the returning customer by check the
  # buyer's stripe_customer_token.
  def returning_customer(buyer)
    returning_customer = PaymentGateway.retrieve_customer(buyer.stripe_customer_token)
    self.token         = PaymentGateway.create_token(self, returning_customer)

    PaymentGateway.create_charge(self)
  end

  # Creates the stripe charge object for a first time buyer.
  def first_time_buyer(buyer)
    customer   = PaymentGateway.create_customer(self)
    self.token = PaymentGateway.create_token(self, customer)

    PaymentGateway.create_charge(self)
    buyer.update_attribute(:stripe_customer_token, customer.id)
  end

  # Creates the stripe charge object for the returning customer by check the
  # donator's stripe_customer_token.
  def returning_donator(donator)
    # returning_customer = Stripe::Customer.retrieve(donator.stripe_customer_token)
    returning_customer = PaymentGateway.retrieve_customer(donator.stripe_customer_token)
    self.token         = PaymentGateway.create_token(self, returning_customer)

    PaymentGateway.create_charge(self)
  end

  # Creates the Stripe charge object for a first time donator.
  def first_time_donator(donator)
    customer   = PaymentGateway.create_customer(self)
    self.token = PaymentGateway.create_token(self, customer)

    PaymentGateway.create_charge(self)
    donator.update_attribute(:stripe_customer_token, customer.id)
  end

  #- Helper methods

  def merchandise_buy_or_donate?
    @merchandise.buttontype == 'Buy' ? true : false
  end

  def retrieve_customer_card(current_user)
    customer = Stripe::Customer.retrieve(current_user.stripe_customer_token)
    sourceid = customer.default_source
    card     = customer.sources.retrieve(sourceid)
    card
  end

  def is_anonymous?
    self.email.present? ? true : false
  end

  # def retrieve_seller_stripe_account(seller)
  #   Stripe::Account.retrieve(seller.stripeid)
  # end

  def calculate_amount(pricesold)
    (pricesold * 100).to_i
  end

  def calculate_authorcut(pricesold)
    ((pricesold * 92.1).to_i - 30).to_f/100
  end

  def calculate_application_fee_amount(amount)
    ((amount * 5)/100)
  end
end
