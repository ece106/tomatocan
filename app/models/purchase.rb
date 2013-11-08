class Purchase < ActiveRecord::Base

  attr_accessible :stripe_customer_token, :author_id, :book_id, :stripe_card_token
  attr_accessor :stripe_card_token
  
  belongs_to :book


  def save_with_payment
    if valid?

      customer = Stripe::Customer.create(
        :card => stripe_card_token,
        :description => "customer email" 
      )
      self.stripe_customer_token = customer.id


      charge = Stripe::Charge.create(
        :amount => 1000,
        :currency => "usd",
        :customer => customer.id,
#        :card => stripe_card_token,
        :description => "book title"
      )
      save!
    end

  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  
  end
end
