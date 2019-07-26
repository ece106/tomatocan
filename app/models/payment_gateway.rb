module PaymentGateway
  class StripePortal
    attr_accessor :customer, :token, :charge

    def self.create_customer(purchase, merchandise)
      Stripe::Customer.create({
        source: purchase.stripe_card_token,
        description: merchandise.desc,
        email: purchase.email
      })
    end

    def self.create_token(customer_id, seller_stripe_account_id)
      Stripe::Token.create(
        {
          customer: customer_id
        },
        {
          stripe_account: seller_stripe_account_id
        }
      )
    end

    def self.create_charge(amount, token, merchandise, application_fee, seller_stripe_account)
      Stripe::Charge.create(
        {
          amount: amount,
          currency: "usd",
          source: token.id,
          description: merchandise.desc,
          application_fee: application_fee
        },
        {
          stripe_account: seller_stripe_account.id
        }
      )
    end
  end
end
