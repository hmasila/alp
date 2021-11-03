price = Stripe::Price.create({
  unit_amount: 2000,
  currency: 'usd',
  product: 'prod_JBdnu9KDSZjPW9',
})

subscription = Stripe::Subscription.create({
  customer: current_user.stripe_customer_id,
  items: [
    {
      price: price.id,
    },
  ],
  trial_end: 1610403705,
})


# if you want to use checkout session

Stripe::Checkout::Session.create({
  success_url: 'https://example.com/success',
  cancel_url: 'https://example.com/cancel',
  payment_method_types: ['card'],
  line_items: [
    {price: price_key, quantity: 2},
  ],
  mode: 'subscription',
  subscription_data: {
    trial_end: (Time.now + 5.days).to_i
  }
})


# webhooks controller

when 'customer.subscription.trial_will_end'
  subscription = event.data.object
  @user = User.find_by(stripe_customer_id: subscription.customer)
  @user.update(
    subscription_status: 'incomplete',
  )
end


def price_key
  if params[:subscription_option] == 'option1'
    'price_key_1'
  else
    'price_key_2'
  end
end
