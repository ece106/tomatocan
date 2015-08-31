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
      purchaser = User.find(self.user_id)
      self.pricesold = @book.price
      self.author_id = @book.user.id

      if(p = Purchase.find_by_user_id(self.user_id)) 
        customer_id = p.stripe_customer_token
        puts "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFf"
        puts customer_id
      else
        puts "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCc"
        puts stripe_card_token
        puts purchaser.name
        customer = Stripe::Customer.create(
           :source => stripe_card_token,
#            :object => "card",
#            :number => "4242424242424242",
#            :exp_month => "1",
#            :exp_year => "2016",
#            :cvc => "123"
#          },
          :description => purchaser.name, 
          :email => purchaser.email
        )
        customer_id = customer.id
      end
      self.stripe_customer_token = customer_id

      charge = Stripe::Charge.create(
        :amount => (@book.price * 100).to_i, 
        :currency => "usd",
        :customer => customer_id,
        #  :card => stripe_card_token,
        :description => @book.title 
      )
      save!
    end

  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  
  end
end
