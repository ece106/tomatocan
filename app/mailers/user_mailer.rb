class UserMailer < ApplicationMailer
  before_action do
    @user = params[:user]
    @seller = params[:seller]
    @purchase = params[:purchase]
    @merchandise = params[:merchandise]
  end
  def welcome_email
    @url = home_url(host:'crowdpublish.TV')
    mail(to: @user.email, subject: "Welcome")
  end
  # These mailers could use another reason for people to come back to the site
  # Could use suggested videos based on purchase or donation from the search feature in the future
  def purchase_saved
    @url = home_url(host: 'crowdpublish.TV')
    mail(to: @user.email, subject: 'Your purchase has been confirmed')
  end
  def donation_saved
    @url = home_url(host:'crowdpublish.TV')
    mail(to: @user.email, subject: 'Your donation is appreciated')
  end
end