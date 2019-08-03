module PaymentGateway

  def self.create_customer(purchase)
    Stripe::Customer.create({
      source: purchase.stripe_card_token,
      description: purchase.shipaddress,
      email: purchase.email
    })
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

  def self.create_anonymous_charge(purchase, currency)
    Stripe::Charge.create(
      {
        amount: purchase.amount,
        currency: currency,
        source: purchase.stripe_card_token,
        description: purchase.shipaddress,
        application_fee: purchase.application_fee,
      },
      {
        stripe_account: purchase.seller_stripe_account.id
      }
    )
  end

  def self.create_charge(purchase, currency)
    Stripe::Charge.create(
      {
        amount: purchase.amount,
        currency: currency,
        source: purchase.token.id,
        description: purchase.shipaddress,
        application_fee: purchase.application_fee
      },
      {
        stripe_account: purchase.seller_stripe_account.id
      }
    )
  end

end
