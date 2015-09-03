jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  purchase.setupForm()

purchase =
  setupForm: ->
    $('#new_purchase').submit ->
      alert(card)
      $('input[type=submit]').prop('disabled', true)
      if $('#card_number').length
        if card == "existingcustomer"
          alert(card + " existing")
          true
        else
          alert(card + " purch.process")
          purchase.processCard()
          false
      else
        alert(card + " else")
        true

  processCard: ->
    alert($('#card_number').val() + " process")
    card =
      {number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()}
    Stripe.createToken(card, purchase.handleStripeResponse)

  handleStripeResponse: (status, response) ->
    if status == 200
      alert(response.id)
      $('#purchase_stripe_card_token').val(response.id)
      $('#new_purchase')[0].submit()
    else
      alert(response.error.message) 
      $('#stripe_error').text(response.error.message)
      $('input[type=submit]').attr('disabled', false)
