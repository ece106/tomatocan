class Purchase < ActiveRecord::Base

  attr_accessible :stripe_customer_token, :book_id, :stripe_card_token, :user_id
  attr_accessor :stripe_card_token
  
  belongs_to :book
  belongs_to :user
  validates :user_id, presence: true
  validates :book_id, presence: true

  def save_with_payment
    if valid?
      customer = Stripe::Customer.create(
        :card => stripe_card_token,
        :description => "get user email address, product" 
      )
      self.stripe_customer_token = customer.id
      #self.user_id = current_user.id

      charge = Stripe::Charge.create(
        :amount => 500,
        :currency => "usd",
        :customer => customer.id,
        # :card => stripe_card_token,
        :description => "book title"
      )
      save!
      #save_stripe_customer_id(user, customer.id)
    end

  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  
  end
end
