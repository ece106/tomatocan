class Purchase < ActiveRecord::Base

#  attr_accessible :stripe_customer_token, :bookfiletype, :book_id, :stripe_card_token, :user_id
#  attr_reader :stripe_card_token
  
  belongs_to :book
  belongs_to :user
  validates :user_id, presence: true
  validates :book_id, presence: true
#  validates :bookfiletype, presence: true

  def save_with_payment
    #this will have to change when using cart instead of purchasing each book individually
    #if valid?   
      @book = Book.find(self.book_id)
      @purchaser = User.find(self.user_id)
      self.pricesold = @book.price
      self.authorcut = ((@book.price * 80).to_i).to_f/100 #this calc may be different for different products & different currencies. It's an important part of the CrowdPublishTV business model. Perhaps it should be somewhere more prominent
      self.author_id = @book.user_id #do I need to save this in purchase incase bookauthor changes?
      author = User.find(@book.user_id) #but what if purchase consisted of items from several authors
      authoraccount = Stripe::Account.retrieve(author.stripeid) 

      if(@purchaser.stripe_customer_token) 
        customer_id = @purchaser.stripe_customer_token
        customer = Stripe::Customer.retrieve(customer_id)
        #card = customer.sources.create(:source => stripe_card_token) #I think this is only if existing/previous customer wants to enter new card
      else #if valid?
        customer = Stripe::Customer.create(
          :source => stripe_card_token,
          :description => @purchaser.name, # what info do I really want here
          :email => @purchaser.email
        )
        @purchaser.update_attribute(:stripe_customer_token, customer.id)
      end
      card_id = customer.default_source
      cardtoken = Stripe::Token.create(
        {:customer => customer.id, :card => card_id},
        {:stripe_account => authoraccount.id } # id of the connected account
      )
      charge = Stripe::Charge.create( {
        :amount => (@book.price * 100).to_i,  #this is the amt charged to the customer's credit card
        :currency => "usd",
#        :customer => customer_id,
        :source => cardtoken,
        :description => @book.title, # what info do I really want here 
        :application_fee => ((@book.price - self.authorcut)*100).to_i #how much crowdpublishtv keeps: crowdpublishtv is charged a fee by stripe, so must keep more than that fee
        },
        {:stripe_account => authoraccount.id }
      )
      save!

  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  
  end
end
