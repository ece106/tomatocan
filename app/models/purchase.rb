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
         #what does it matter whether donation or purchase. Money is money.
        is_userloggedin? ? nonuser_charge : user_merchandise_payment
      else
        setup_payment_information
        puts "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"
        merchandise_payment
        puts "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC"
      end

      save!
    rescue Stripe::InvalidRequestError => e
    end
  end

  def merchandise_payment
    is_userloggedin? ? nonuser_charge : user_merchandise_payment
  end

  def nonuser_charge
    PaymentGateway.create_nonuser_charge(self)
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
    self.authorcut             = calculate_authorcut(self.pricesold) #i thinq this is obsolete
    self.amount                = calculate_amount(self.pricesold)
    self.application_fee_amount       = calculate_application_fee_amount(self.amount)
    self.currency              = CURRENCY
  end

  # Checks if the user is anonymous or returning buyer.
  def user_merchandise_payment
    puts "DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDd"
    buyer = User.find(self.user_id)
puts "EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE"
    buyer.stripe_customer_token.present? ? returning_customer(buyer) : first_time_buyer(buyer)
    puts "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"
  end

  # Creates the stripe charge object for the returning customer by check the
  # buyer's stripe_customer_token.
  def returning_customer(buyer)
    puts "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG"
    returning_customer = PaymentGateway.retrieve_customer(buyer.stripe_customer_token)
    puts "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH"
    self.token         = PaymentGateway.create_token(self, returning_customer)
    puts "IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII"

    PaymentGateway.create_charge(self)
    puts "JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ"
  end

  # Creates the stripe charge object for a first time buyer.
  def first_time_buyer(buyer)
    puts "FFFFFFFFFIIIIIIIRRRRRRRRRRRRRRSSSSSSSSSSSSSSSSSSTTTTTTTTTTTTT"
    customer   = PaymentGateway.create_customer(self)
    puts "CCCCCCCCCCCCCRRRRRRRRRREATEEEEEEEEEEEEEEEE CUSTOMER"
    puts customer.id
    self.token = PaymentGateway.create_token(self, customer)
    puts "CCCCCCCCCCCCCRRRRRRRRRREATEEEEEEEEEEEEEEEE TOKEN"

    PaymentGateway.create_charge(self)
    puts "UUUUUUUUUUUUUUUUUUUUUUUPPPPPPPPPPPPPPPPPPPPPDDDATE"
    buyer.update_attribute(:stripe_customer_token, customer.id)
  end

  def retrieve_customer_card(current_user) #this isnt used anywhere
    customer = Stripe::Customer.retrieve(current_user.stripe_customer_token)
    sourceid = customer.default_source
    card     = customer.sources.retrieve(sourceid)
  end

  def is_userloggedin?
    self.email.present? ? true : false
  end

  def calculate_amount(pricesold)
    #do we really need all these obscurely named 1 line methods
    (pricesold * 100).to_i
  end

  def calculate_authorcut(pricesold)
    # i dont thinq this is used with current version of stripe. But I thinq it still gets saved in db
    ((pricesold * 92.1).to_i - 30).to_f/100
  end

  def calculate_application_fee_amount(amount)
    ((amount * 5)/100)
  end
end
