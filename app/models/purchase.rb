class Purchase < ApplicationRecord
  include PaymentGateway

  belongs_to :user, optional: true
  belongs_to :merchandise, optional: true

  validates :author_id, presence: true # author means seller
  validates :pricesold, presence: true
  validates :authorcut, presence: true

  # Buy
  def save_payment_with_merchandise
    setup_payment_information

    if self.email.present?
      # process_nonuser_payment_with_merchandise
    else
      # process_user_payment_with_merchandise
    end
  end

  # Donation
  def save_payment_with_donation
    setup_payment_information

    if self.email.present?
      process_non_user_donation # Non user donation
    else
      process_user_donation # User donation
    end
  end

  def setup_payment_information
    @merchandise           = Merchandise.find(self.merchandise_id)
    self.update_attribute(:pricesold, @merchandise.price)
    @seller                = User.find(@merchandise.user_id)
    @seller_stripe_account = retrieve_seller_stripe_account(@seller)
    self.author_id         = @seller.id
    self.authorcut         = calculate_authorcut
    @amount                = calculate_amount
    @application_fee       = calculate_application_fee @amount
  end

  def process_user_donation
    @donator = User.find(self.user_id)

    # NOTE: Check to see if the donator has donated before.
    # If they have donated before, then retrive the stripe customer token
    if @donator.stripe_customer_token.present? # Returning donator
      # Retrieve the returning customer Stripe information
      @returning_customer = Stripe::Customer.retrieve(@donator.stripe_customer_token)

      # Create a token on behalf the returning customer's Stripe information
      @token = Stripe::Token.create(
        {
          customer: @returning_customer.id
        },
        {
          stripe_account: @seller_stripe_account.id
        }
      )

      # Create the charge for the returning customer
      @charge = Stripe::Charge.create(
        {
          amount: @amount,
          currency: 'usd',
          source: @token.id,
          description: @merchandise.desc,
          application_fee: @application_fee
        },
        {
          stripe_account: @seller_stripe_account.id
        }
      )
      # @returning_donator.source = self.stripe_card_token
      # @returning_donator.save
    else
      # User making their first donation
      # NOTE:if self.stripe_card_token is nil or "", this will throw exception here.
      # This edge case happens when the form is "auto-filled"
      # @new_donator = PaymentGateway::StripePortal.create_customer(self, merchandise)
      # @token = PaymentGateway::StripePortal.create_token(@new_donator.id, @seller_stripe_account.id)
      # PaymentGateway::StripePortal.create_charge(@amount, @token, @merchandise, @application_fee, @seller_stripe_account)
      @customer = Stripe::Customer.create({
        source: self.stripe_card_token,
        description: @merchandise.desc,
        email: self.email,
      })

      @donator.update_attribute(:stripe_customer_token, @customer.id)

      @token = Stripe::Token.create(
        {
          customer: @customer.id
        },
        {
          stripe_account: @seller_stripe_account.id
        }
      )

      @charge = Stripe::Charge.create(
        {
          amount: @amount,
          currency: "usd",
          source: @token.id,
          description: @merchandise.desc,
          application_fee: @application_fee
        },
        {
          stripe_account: @seller_stripe_account.id
        }
      )
    end

    save!
  end

  def is_returning_customer?
    return true if self.stripe_customer_token.present?
  end

  def process_non_user_donation
    @charge = Stripe::Charge.create(
      {
        amount: @amount,
        currency: 'usd',
        source: self.stripe_card_token,
        description: @merchandise.desc,
        application_fee: @application_fee
      },
      {
        stripe_account: @seller_stripe_account.id
      }
    );

    save!
  end

  private

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
