class UserMailer < ApplicationMailer
  before_action do
    @user = params[:user]
    @seller = params[:seller]
    @purchase = params[:purchase]
    @merchandise = params[:merchandise]
  end
  before_action :set_url ,only: [:welcome_email,:purchase_saved,:donation_saved]
  def welcome_email
    mail(to: @user.email, subject: "Welcome")
  end
  # These mailers could use another reason for people to come back to the site
  # Could use suggested videos
  def purchase_saved
    mail(to: @user.email, subject: 'Your purchase has been confirmed')
  end
  def donation_saved
    mail(to: @user.email, subject: 'Your donation is appreciated')
  end
  private
  def set_url
    @url = home_url(host: 'crowdpublish.TV')
    # if you need more url options you can use this method to expand
  end
end