Rails.configuration.stripe = {
  publishable_key:  ENV['STRIPE_PUBLISHABLE_KEY'] || 'pk_test_6pRNASCoBOKtIshFeQd4XMUh',
  secret_key:       ENV['STRIPE_SECRET_KEY'] || 'sk_test_lqEFdxAoWtsGNdDLUgLT5HfV'
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
