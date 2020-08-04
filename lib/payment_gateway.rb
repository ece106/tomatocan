  # frozen_string_literal: true

# Description/Explanation: PaymentGateway module methods will receive the
# purchase object as a parameter with valid attributes in order to process the
# Stripe objects required to process a payment through the Stripe API.
#
# Do not remove the frozen string literal comment. It is a 'magic' ruby comment
# that ensures that all string literals in this module are frozen, as if
# .freeze has been called on each of the strings.
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
    Stripe::Token.create(
      {
        customer: returning_customer.id
      },
      {
        stripe_account: purchase.seller_stripe_account.id
      }
    )
  end

  def self.create_anonymous_charge(purchase)
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

  def self.create_charge(purchase)
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
