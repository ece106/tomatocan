class UserMailer < ApplicationMailer

  def welcome_email(user)
    @user = user
    @url = home_url(host:'crowdpublish.TV')
    mail(to: @user.email, subject: "Welcome")
  end
  def purchase_saved(seller,user,purchase,merchandise)
    @seller = seller
    @user = user
    @purchase = purchase
    @merchandise = merchandise
    mail(to: @user.email, subject: 'Your purchase has been confirmed')
  end
  def donation_saved(seller,user,purchase)
    @seller = seller
    @user = user
    @purchase = purchase
    mail(to: @user.email, subject: 'Your donation is appreciated')
  end

end