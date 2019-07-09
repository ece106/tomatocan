class UserMailer < ApplicationMailer
 
  before_action do
    @user = params[:user]
    @seller = params[:seller]
    @purchase = params[:purchase]
    @merchandise = params[:merchandise]
  end

  before_action :set_url

  def welcome_email
    mail(to: @user.email, subject: "Welcome")
  end
  # purchase and donation saved could use another reason for people to come back to the site
  # Could use suggested videos

  def purchase_saved
    mail(to: @user.email, subject: 'Your purchase has been confirmed')
  end

  def donation_saved
    mail(to: @user.email, subject: 'Your donation is appreciated')
  end

  def purchase_received
    mail(to: @seller.email, subject: "#{@user.name} has made a purchase")
  end

  def donation_received
    mail(to: @seller.email, subject: "#{@user.name} has made a donation")
  end

  private

  def set_url
    @home_url = home_url(host: 'crowdpublish.TV')
    # if you need more url options you can use this method to expand
  end
end
