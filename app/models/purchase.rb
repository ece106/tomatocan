class Purchase < ApplicationRecord
  belongs_to :user, optional: true 
  belongs_to :merchandise, optional: true

  validates :author_id, presence: true # author means seller
  validates :pricesold, presence: true
  validates :authorcut, presence: true #authorcut should only be used in our db when transaction is for a connected acnt

  include PaymentGateway

  attr_accessor :card_number, :card_code, :amount, :application_fee_amount, :seller,
    :seller_stripe_account, :token, :currency

  CURRENCY = 'usd'.freeze

  def setup_payment_info
    # self.update_attribute(:pricesold, @merchandise.price)
    # self.seller_stripe_account = retrieve_seller_stripe_account(seller)
    self.seller_stripe_account = PaymentGateway.retrieve_seller_account(seller.stripeid)
    self.authorcut             = calculate_authorcut(self.pricesold) #i thinq this is obsolete
    self.amount                = (self.pricesold * 100).to_i
    self.application_fee_amount = (amount * 5)/100
    self.currency              = CURRENCY
  end

  def save_with_payment
    begin
      # Check for a defaut donation
      if self.merchandise_id.nil?
        self.seller = User.find(self.author_id)
        setup_payment_info
      else
        @merchandise = Merchandise.find(self.merchandise_id)
        self.pricesold = @merchandise.price
        self.seller = User.find(@merchandise.user_id)
        self.author_id = seller.id
        setup_payment_info
      end
      is_userloggedin? ? nonuser_charge : user_charge

      save!
    rescue Stripe::InvalidRequestError => e
    end
  end

  def nonuser_charge
    PaymentGateway.create_nonuser_charge(self)
  end

  def user_charge
    buyer = User.find(self.user_id)
    if buyer.stripe_customer_token.present? 
      customer = PaymentGateway.retrieve_customer(buyer.stripe_customer_token)
    else
      customer   = PaymentGateway.create_customer(self)
      buyer.update_attribute(:stripe_customer_token, customer.id)
    end
    self.token = PaymentGateway.create_token(self, customer)
    PaymentGateway.create_charge(self)
  end

  def retrieve_customer_card(current_user) #this isnt used anywhere
    customer = Stripe::Customer.retrieve(current_user.stripe_customer_token)
    sourceid = customer.default_source
    card     = customer.sources.retrieve(sourceid)
  end

  def is_userloggedin? #users not logged in must submit email address with purchase
    self.email.present? ? true : false
  end

  def calculate_authorcut(pricesold)
    # This gets saved in db for connected acnt records
    ((pricesold * 92.1).to_i - 30).to_f/100
  end

end
