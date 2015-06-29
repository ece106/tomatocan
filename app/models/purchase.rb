class Purchase < ActiveRecord::Base

#  attr_accessible :stripe_customer_token, :bookfiletype, :book_id, :stripe_card_token, :user_id
#  attr_reader :stripe_card_token
  
  belongs_to :book
  belongs_to :user
  validates :user_id, presence: true
  validates :book_id, presence: true
#  validates :bookfiletype, presence: true

  def save_with_payment
    if valid?
#      @author = User.find(self.author_id)
      @book = Book.find(self.book_id)
      @purchaser = User.find(self.user_id)
      self.pricesold = @book.price
      self.author_id = @book.user.id

      customer = Stripe::Customer.create(
        :source => stripe_card_token,
        :description => @book.title, 
        :email => @purchaser.email
      )
      self.stripe_customer_token = customer.id

      charge = Stripe::Charge.create(
        :amount => (@book.price * 100).to_i, 
        :currency => "usd",
        :customer => customer.id,
        #  :card => stripe_card_token,
        :description => @book.title 
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
