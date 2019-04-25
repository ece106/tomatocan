
class Purchase < ApplicationRecord

  #  attr_accessible :stripe_customer_token, :bookfiletype, :book_id, :stripe_card_token, :user_id, :merchandise_id
  #  attr_reader :stripe_card_token
    
  #  belongs_to :book, optional: true
    belongs_to :user, optional: true
    belongs_to :merchandise, optional: true
  #  validates :user_id, presence: true
    validates :author_id, presence: true # author means seller
    validates :pricesold, presence: true
    validates :authorcut, presence: true
  #  validates :merchandise_id, presence: true
  #  validates :email, :presence => true, :if => loggedin  #cant validate this
  #  validates :bookfiletype, presence: true
    
    def save_with_payment
      if(self.merchandise_id.present?)
        @merchandise = Merchandise.find(self.merchandise_id)
        self.pricesold = @merchandise.price
        self.author_id = @merchandise.user_id 
        seller = User.find(@merchandise.user_id)
        amt = (@merchandise.price * 100).to_i 
        desc = @merchandise.name 
        %%if self.group_id.present?
          self.groupcut = ((@merchandise.price * 5).to_i).to_f/100
          self.authorcut = ((@merchandise.price * 92).to_i - 30).to_f/100 - self.groupcut
        else% 
          self.groupcut = 0.0
          self.authorcut = ((@merchandise.price * 92.1).to_i - 30).to_f/100
        %%end%
        
      else #If a donation is being made
        self.pricesold = pricesold
        self.author_id = author_id
        seller = User.find(self.author_id)
        amt = (pricesold * 100).to_i 
        self.authorcut = ((pricesold * 92.1).to_i - 30).to_f/100
        if self.user_id.present?
          purchaser = User.find(self.user_id)
          desc = "Donation of $" + String(pricesold) + " from " + purchaser.name 
        else
          desc = "Donation of $" + String(pricesold) + " from anonymous customer"
        end
      end
  
      sellerstripeaccount = Stripe::Account.retrieve(seller.stripeid) 
        %%if self.group_id.present? #not used right now
          group = Group.find(self.group_id)
          groupstripeaccount = Stripe::Account.retrieve(group.stripeid) 
        end%
  
      if self.email.present?
        customer = Stripe::Customer.create(
          :source => stripe_card_token,  #token from? purchases.js.coffee?
          :description => "anonymous customer", # what info do I really want here
          :email => self.email
        )
      else
        @purchaser = User.find(self.user_id)
        if(@purchaser.stripe_customer_token).present?
          customer = Stripe::Customer.retrieve(@purchaser.stripe_customer_token)
          if stripe_card_token.present?
            customer.source = stripe_card_token
            customer.save
          end
        else 
          customer = Stripe::Customer.create(
            :source => stripe_card_token,  #token from? purchases.js.coffee?
            :description => @purchaser.name, # what info do I really want here
            :email => @purchaser.email
          )
          @purchaser.update_attribute(:stripe_customer_token, customer.id)
        end
      end
  
      if seller.id == 143 || seller.id == 1337 || seller.id == 1345 
        charge = Stripe::Charge.create( {
          :amount => amt, 
          :currency => "usd",
          :customer => customer.id, 
          :description => desc 
          } 
        )
      else  
  #      transfergrp = "purchase" + (Purchase.maximum(:id) + 1).to_s  #won't work when lots of simultaneous purchases
        appfee = ((amt * 5)/100)
  
        token = Stripe::Token.create({
          :customer => customer.id,
        }, {:stripe_account => sellerstripeaccount.id} )
  
        charge = Stripe::Charge.create( {
          :amount => amt,  # amt charged to customer's credit card
          :currency => "usd",
          :source => token.id,  #token from? purchases.js.coffee?
  #        :customer => customer.id,  # This will be necessary for subscriptions. See Stripe Docs & Stackoverflow
          :description => desc,  
          :application_fee => appfee,  #this is amt crowdpublishtv keeps - it includes groupcut since group gets paid some time later
  #        :transfer_group => transfergrp
          } ,
           {:stripe_account => sellerstripeaccount.id } #appfee only needed for old way of 1 connected acct per transaction
        )
  #      transfer = Stripe::Transfer.create({
  #        :amount => (self.authorcut * 100).to_i,
  #        :currency => "usd",
  #        :destination => sellerstripeaccount.id,
  #        :source_transaction => charge.id, # stripe attempts transfer when this isn't here, even when transfer_group is
  #        :transfer_group => transfergrp #does this mean anything when there is a source transaction?
  #      })
        if self.group_id.present?  #this is for when groups affiliate to help sell
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
          errors.add(:base, "You have to buy a Perk to make a purchase")
        end
      end
  
  end