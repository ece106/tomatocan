class Purchase < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :merchandise, optional: true

  validates :author_id, presence: true # author means seller
  validates :pricesold, presence: true
  validates :authorcut, presence: true

  # Buy
  def save_with_payment_merchandise
  end

  # Donation
  def save_with_payment_donation
    # Set up prerequisite info
    @merchandise           = Merchandise.find(self.merchandise_id)
    @seller                = User.find(@merchandise.user_id)
    @seller_stripe_account = retrieve_seller_stripe_account(@seller)
    self.pricesold         = @merchandise.price
    self.author_id         = @seller.id
    self.authorcut         = calculate_authorcut
    amount                 = calculate_amount

    customer = Stripe::Customer.create({
      source: self.stripe_card_token,
      description: @merchandise.desc,
      email: self.email
    })

    charge = Stripe::Charge.create({
      amount: amount,
      currency: "usd",
      customer: customer.id,
      description: @merchandise.desc
    })

    save!
  end

  # def get_seller
  #   User.find(@merchandise.user_id)
  # end

  # def get_merchandise
  #   Merchandise.find(self.merchandise_id)
  # end

  # def get_purchase_recipient_email
  #   if self.email?
  #     self.email
  #   else
  #     user = User.find(self.user_id)
  #     user.email
  #   end
  # end

  private

  def retrieve_seller_stripe_account(seller)
    Stripe::Account.retrieve(seller.stripeid)
  end

  def is_user?
    return true if self.email.present?
  end

  def calculate_amount
    (self.pricesold * 100).to_i
  end

  def calculate_authorcut
    ((self.pricesold * 92.1).to_i - 30).to_f/100
  end

end
