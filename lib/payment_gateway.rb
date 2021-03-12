  # frozen_string_literal: true

#Why is this hiding in the lib directory 

# Description/Explanation: PaymentGateway module methods will receive the
# purchase object as a parameter with valid attributes in order to process the
# Stripe objects required to process a payment through the Stripe API.
#
# Do not remove the frozen string literal comment. It is a 'magic' ruby comment
# that ensures that all string literals in this module are frozen, as if
# .freeze has been called on each of the strings. ??? Really? Is that necessary?

module PaymentGateway

  def self.retrieve_seller_account(seller_stripeid)
    Stripe::Account.retrieve(seller_stripeid)
  end

  def self.retrieve_customer(stripe_customer_token)
    Stripe::Customer.retrieve(stripe_customer_token)
  end

  def self.create_customer(purchase)
    Stripe::Customer.create(
      source: purchase.stripe_card_token,
      description: purchase.shipaddress,
      email: purchase.email
    )
  end

  def self.create_token(purchase, returning_customer)
    if purchase.merchandise_id.present?
      merch = Merchandise.find(purchase.merchandise_id)
      if merch.user_id == 1 || merch.user_id == 553
      else
        Stripe::Token.create(
        {
          customer: returning_customer.id
        },
        {
          stripe_account: purchase.seller_stripe_account.id
        }
        )
      end
    else
      Stripe::Token.create(
      {
        customer: returning_customer.id
      },
      {
        stripe_account: purchase.seller_stripe_account.id
      }
      )
    end
  end

  def self.create_nonuser_charge(purchase)
    if purchase.merchandise_id.present?
      merch = Merchandise.find(purchase.merchandise_id)
      if merch.user_id == 1 || merch.user_id == 553
        lisasale_nouser(purchase)
      else
        sale_nouser(purchase)
      end
    else
      sale_nouser(purchase)
    end
  end

  def self.sale_nouser(purchase)
    Stripe::Charge.create(
      {
        amount: purchase.amount,
        currency: purchase.currency,
        source: purchase.stripe_card_token,
        description: purchase.shipaddress,
        application_fee_amount: purchase.application_fee_amount
      },
      {
        stripe_account: purchase.seller_stripe_account.id
      }
    )
  end

  def self.lisasale_nouser(purchase)
    Stripe::Charge.create(
      {
          amount: (purchase.pricesold * 100).to_i,
          currency: "usd",
          source: purchase.stripe_card_token,
          description: purchase.shipaddress
      },
    )
  end

  def self.create_charge(purchase)
    if purchase.merchandise_id.present?
      merch = Merchandise.find(purchase.merchandise_id)
      if merch.user_id == 1 || merch.user_id == 553
        lisasale_userloggedin(purchase)
      else
        sale_userloggedin(purchase)
      end
    else
      sale_userloggedin(purchase)
    end
  end

  def self.lisasale_userloggedin(purchase)
    buyer = User.find(purchase.user_id)
    if buyer.stripe_customer_token.present? 
    else
      customer = self.create_customer(purchase)
      buyer.update_attribute(:stripe_customer_token, customer.id)
    end

    Stripe::Charge.create(
      {
        amount: purchase.amount,
        currency: purchase.currency,
        customer: buyer.stripe_customer_token,
        description: purchase.shipaddress
      },
     )
  end

  def self.sale_userloggedin(purchase)
    Stripe::Charge.create(
      {
        amount: purchase.amount,
        currency: purchase.currency,
        source: purchase.token.id,
        description: purchase.shipaddress,
        application_fee_amount: purchase.application_fee_amount
      },
      {
        stripe_account: purchase.seller_stripe_account.id
      }
    )
  end

end
