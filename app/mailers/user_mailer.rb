class UserMailer < ApplicationMailer

  def welcome_email(user)
    @user = user
    @url = home_url(host:'crowdpublish.TV')
    mail(to: @user.email, subject: "Welcome")
  end
  # These mailers could use another reason for people to come back to the site
  # Could use suggested videos based on purchase or donation from the search feature in the future
  def purchase_saved(seller,user,purchase,merchandise)
    @seller = seller
    @user = user
    @purchase = purchase
    @merchandise = merchandise
    @url = home_url(host: 'crowdpublish.TV')
    mail(to: @user.email, subject: 'Your purchase has been confirmed')
  end
  def donation_saved(seller,user,purchase)
    @seller = seller
    @user = user
    @purchase = purchase
    @url = home_url(host:'crowdpublish.TV')
    mail(to: @user.email, subject: 'Your donation is appreciated')
  end
end