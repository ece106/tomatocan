class Purchase < ApplicationRecord

#  attr_accessible :stripe_customer_token, :bookfiletype, :book_id, :stripe_card_token, :user_id
#  attr_reader :stripe_card_token
  
  belongs_to :book, optional: true
  belongs_to :user
  belongs_to :merchandise, optional: true
  validates :user_id, presence: true
  validate :book_id_or_merchandise_id
#  validates :bookfiletype, presence: true

  def save_with_payment
    if self.book_id.present?
      @book = Book.find(self.book_id)  #do any of these variables need to be nonlocal
      self.pricesold = @book.price 
      self.author_id = @book.user_id 
      author = User.find(@book.user_id) 
      amt = (@book.price * 100).to_i 
      desc = @book.title # what info do we really want here 
      if self.group_id.present?
        self.groupcut = ((@book.price * 5).to_i).to_f/100
        self.authorcut = ((@book.price * 92).to_i - 30).to_f/100 - self.groupcut
      else
        self.groupcut = 0.0
        self.authorcut = ((@book.price * 92).to_i - 30).to_f/100 
      end
    end  
    if self.merchandise_id.present?
      @merchandise = Merchandise.find(self.merchandise_id)
      self.pricesold = @merchandise.price
      self.author_id = @merchandise.user_id 
      author = User.find(@merchandise.user_id)
      amt = (@merchandise.price * 100).to_i 
      desc = @merchandise.name 
      if self.group_id.present?
        self.groupcut = ((@merchandise.price * 5).to_i).to_f/100
        self.authorcut = ((@merchandise.price * 92).to_i - 30).to_f/100 - self.groupcut
      else
        self.groupcut = 0.0
        self.authorcut = ((@merchandise.price * 92).to_i -30).to_f/100
      end
    end  

    @purchaser = User.find(self.user_id)
    authorstripeaccount = Stripe::Account.retrieve(author.stripeid) 
    if self.group_id.present?
      group = Group.find(self.group_id)
      groupstripeaccount = Stripe::Account.retrieve(group.stripeid) 
    end

    if(@purchaser.stripe_customer_token).present?
      customer = Stripe::Customer.retrieve(@purchaser.stripe_customer_token)
      if stripe_card_token.present?
        customer.source = stripe_card_token
        customer.save
      end
    else 
      customer = Stripe::Customer.create(
        :source => stripe_card_token,  #where does this token come from? purchases.js.coffee?
        :description => @purchaser.name, # what info do I really want here
        :email => @purchaser.email
      )
      @purchaser.update_attribute(:stripe_customer_token, customer.id)
    end

    if author.id == 143 
      charge = Stripe::Charge.create( {
        :amount => amt, 
        :currency => "usd",
        :customer => customer.id, 
        :description => desc 
        } 
      )
    else  
      transfergrp = "purchase" + (Purchase.maximum(:id) + 1).to_s  #won't work when lots of simultaneous purchases

      charge = Stripe::Charge.create( {
        :amount => amt,  #this is the amt charged to the customer's credit card
        :currency => "usd",
        :customer => customer.id,  # Don't use :source because we created/use existing customer & card is saved in stripe.
        :description => desc,  
#        :application_fee => appfee,  #this is amt crowdpublishtv keeps - it includes groupcut since group gets paid some time later
        :transfer_group => transfergrp
        } #,
#         {:stripe_account => authorstripeaccount.id } #appfee only needed for old way of 1 connected acct per transaction
      )

      transfer = Stripe::Transfer.create({
        :amount => (self.authorcut * 100).to_i,
        :currency => "usd",
        :destination => authorstripeaccount.id,
        :source_transaction => charge.id, # stripe attempts transfer when this isn't here, even when transfer_group is
        :transfer_group => transfergrp #does this mean anything when there is a source transaction?
      })
      if self.group_id.present?
        transfer = Stripe::Transfer.create({
          :amount => (self.groupcut * 100).to_i,
          :currency => "usd",
          :destination => groupstripeaccount.id,
          :source_transaction => charge.id,
          :transfer_group => transfergrp
        })
      end
    end

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
