module PaymentGateway

  def self.create_customer(customer_params)
    Stripe::Customer.create(customer_params)
  end

  def self.create_token(token_params, token_opts_params)
    Stripe::Token.create(token_params, token_opts_params)
  end

  def self.create_charge(charge_params, charge_opts_params)
    Stripe::Charge.create(charge_params, charge_opts_params)
  end

end
