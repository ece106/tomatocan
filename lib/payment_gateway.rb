module PaymentGateway

  def self.create_customer(customer_params)
    Stripe::Customer.create(customer_params)
  end

  # def self.create_token(token_params, token_opts_params)
    # Stripe::Token.create(token_params, token_opts_params)
  def self.create_token(purchase, returning_customer)
    binding.pry
    Stripe::Token.create(
      {
        customer: returning_customer.id
      },
      {
        stripe_account: purchase.seller_stripe_account.id
      }
    )
    binding.pry
  end

  def self.create_anonymous_charge(purchase, currency, merchandise)
    Stripe::Charge.create(
      {
        amount: purchase.amount,
        currency: currency,
        source: purchase.stripe_card_token,
        description: purchase.shipaddress,
        application_fee: purchase.application_fee
      },
      {
        stripe_account: purchase.seller_stripe_account.id
      }
    )
  end

  def self.create_charge(purchase, currency, merchandise)
    Stripe::Charge.create(
      {
        amount: purchase.amount,
        currency: currency,
        source: purchase.token.id,
        description: merchandise.desc,
        application_fee: purchase.application_fee
      },
      {
        stripe_account: purchase.seller_stripe_account.id
      }
    )
  end

  # def self.create_charge(charge_params, charge_opts_params)
  #   Stripe::Charge.create(charge_params, charge_opts_params)
  # end
end
