class Purchase < ActiveRecord::Base

#  attr_accessible :stripe_customer_token, :bookfiletype, :book_id, :stripe_card_token, :user_id
#  attr_reader :stripe_card_token
  
  belongs_to :book
  belongs_to :user
  belongs_to :merchandise
  validates :user_id, presence: true
  validate :book_id_or_merchandise_id
#  validates :bookfiletype, presence: true

  def save_with_payment
    #this will have to change when using cart instead of purchasing each book individually
    #purchase could hasmany books, merchandise
    #might want different table/model for merch vs books
    #if valid? 
    if self.book_id.present?
      @book = Book.find(self.book_id)
      self.pricesold = @book.price 
      self.authorcut = ((@book.price * 80).to_i).to_f/100 #this calc may be different for different products & different currencies. It's an important part of the CrowdPublishTV business model. Perhaps it should be somewhere more prominent
      self.author_id = @book.user_id 
      author = User.find(@book.user_id) #but what if purchase consisted of items from several authors
      amt = (@book.price * 100).to_i 
      desc = @book.title # what info do we really want here 
      if self.group_id.present?
        self.groupcut = ((@book.price * 5).to_i).to_f/100
        appfee = ((@book.price - self.authorcut - self.groupcut)*100).to_i  #how much crowdpublishtv keeps: crowdpublishtv is charged a fee by stripe, so must keep more than that fee
      else
        appfee = ((@book.price - self.authorcut)*100).to_i  #how much crowdpublishtv keeps: crowdpublishtv is charged a fee by stripe, so must keep more than that fee
      end
    end  
    if self.merchandise_id.present?
      @merchandise = Merchandise.find(self.merchandise_id)
      self.pricesold = @merchandise.price
      self.authorcut = ((@merchandise.price * 80).to_i).to_f/100
      self.author_id = @merchandise.user_id 
      author = User.find(@merchandise.user_id)
      amt = (@merchandise.price * 100).to_i 
      desc = @merchandise.name 
      if self.group_id.present?
        self.groupcut = ((@merchandise.price * 5).to_i).to_f/100
        appfee = ((@merchandise.price - self.authorcut - self.groupcut)*100).to_i 
      end
        appfee = ((@merchandise.price - self.authorcut)*100).to_i 
    end  
    @purchaser = User.find(self.user_id)
    authorstripeaccount = Stripe::Account.retrieve(author.stripeid) 
      if(@purchaser.stripe_customer_token).present?
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
        {:stripe_account => authorstripeaccount.id } # id of the connected account
      )
      charge = Stripe::Charge.create( {
        :amount => amt,  #this is the amt charged to the customer's credit card
        :currency => "usd",
#        :customer => customer_id,
        :source => cardtoken,
        :description => desc,  
        :application_fee => appfee
        },
        {:stripe_account => authorstripeaccount.id }
      )
      save!

  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  
  end

  private

    def book_id_or_merchandise_id
      if book_id.blank? && merchandise_id.blank?
        errors.add(:base, "You have to buy either a book or merchandise")
      end
    end
end
