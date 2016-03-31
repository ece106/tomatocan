class Purchase < ActiveRecord::Base

#  attr_accessible :stripe_customer_token, :bookfiletype, :book_id, :stripe_card_token, :user_id
#  attr_reader :stripe_card_token
  
  belongs_to :book
  belongs_to :user
  validates :user_id, presence: true
  validates :book_id, presence: true
#  validates :bookfiletype, presence: true

  def save_with_payment
    #if valid?
      @book = Book.find(self.book_id)
      @purchaser = User.find(self.user_id)
      self.pricesold = @book.price
      self.author_id = @book.user.id #dont need since I have bookid

      if(@purchaser.stripe_customer_token) 
        puts @purchaser.stripe_customer_token
        customer_id = @purchaser.stripe_customer_token
        customer = Stripe::Customer.retrieve(customer_id)
        card = customer.sources.create(:source => stripe_card_token)
      else #if valid?
        customer = Stripe::Customer.create(
          :source => stripe_card_token,
          :description => @purchaser.name, 
          :email => @purchaser.email
        )
        puts stripe_card_token
        customer_id = customer.id
        card = customer.default_source
        @purchaser.update_attribute(:stripe_customer_token, customer_id)
      end
      charge = Stripe::Charge.create(
        :amount => (@book.price * 100).to_i, 
        :currency => "usd",
        :customer => customer_id,
        :source => card,
        :description => @book.title 
      )
      save!

  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  
  end
end
