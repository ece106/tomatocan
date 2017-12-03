if Rails.env.development? || Rails.env.test?
  Stripe.api_key = STRIPE_SECRET_KEY
else
  Stripe.api_key = ENV['STRIPE_SECRET_KEY']
end