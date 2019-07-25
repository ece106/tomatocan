class Purchase < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :merchandise, optional: true

  validates :author_id, presence: true
  validates :pricesold, presence: true
  validates :authorcut, presence: true

  attr_accessor :seller, :amount, :description, :seller_stripe_account,
    :customer, :returning_customer, :buyer, :appfee, :token, :charge, :transfer

  def get_seller
    User.find(self.author_id)
  end

  # Donation
  def save_donation_payment
  end

  # Buy
  def save_with_payment_merchandise
    # Initial setup
    set_merchandise
    set_seller
    update_author_id
    update_pricesold
    set_amount
    set_description
    update_groupcut
    update_authorcut
    set_seller_stripe_account
    binding.pry
    set_buyer
    binding.pry
    calculate_app_fee
    charge_customer
    save!
  rescue Stripe::InvalidRequestError => e
    puts "Stripe error in model!"
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

  private

  def set_merchandise
    @merchandise = Merchandise.find(self.merchandise_id)
  end

  def set_seller
    @seller = User.find(@merchandise.user_id)
  end

  def update_author_id
    self.author_id = @seller.id
  end

  def update_pricesold
    self.pricesold = @merchandise.price
  end

  def set_amount
    @amount = (@merchandise.price * 100).to_i
  end

  def set_description
    @description = @merchandise.name end

  def update_groupcut
    self.groupcut = 0.0
  end

  def update_authorcut
      self.authorcut = ((@merchandise.price * 92.1).to_i - 30).to_f/100
  end

  def set_seller_stripe_account
    @seller_stripe_account = Stripe::Account.retrieve(@seller.stripeid)
  end

  def set_buyer
    @buyer = User.find(self.user_id)

    if @buyer.stripe_customer_token.present?
      @customer = Stripe::Customer.retrieve(@buyer.stripe_customer_token)

      if self.stripe_card_token.present?
        @customer.source = self.stripe_card_token
        @customer.save
      end
    else
      @customer = Stripe::Customer.create(
        source: self.stripe_card_token,
        description: @merchandise.desc,
        email: @buyer.email
      )
      @customer.update_attribute(:stripe_customer_token, @customer.id)
    end
  end

  def calculate_app_fee
    @app_fee = (@amount * 5)/100
  end

  def charge_customer
    token = Stripe::Token.create(
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
        source: token.id,
        description: @merchandise.description,
        application_fee: @app_fee
      },
      {
        stripe_account: @seller_stripe_account.id
      }
    )
  end

  def transfer_for_group_affiliate
    @transfer = Stripe::Transfer.create({
      amount: (self.groupcut * 100).to_i,
      currency: "usd",
      destination: @group_stripe_account.id,
      source_transaction: @charge.id,
      transfer_group: @transfer_group
    })
  end

end
