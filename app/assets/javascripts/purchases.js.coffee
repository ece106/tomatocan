jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  purchase.setupForm()

purchase =
  setupForm: ->
    $('#new_purchase').submit ->
      $('input[type=submit]').prop('disabled', true)
      if $('#card_number').length
        purchase.processCard()
        false
      else
        true

  processCard: ->
    card =
      {number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()}
    alert($('#card_month').val() + $('#card_year').val())
    Stripe.createToken(card, purchase.handleStripeResponse)
    alert('what happens here')

  handleStripeResponse: (status, response) ->
    alert('ho')
    if status == 200
      alert(response.id)
      $('#purchase_stripe_card_token').val(response.id)
      $('#new_purchase')[0].submit()
    else
      alert(response.error.message) 
      $('#stripe_error').text(response.error.message)
      $('input[type=submit]').attr('disabled', false)
