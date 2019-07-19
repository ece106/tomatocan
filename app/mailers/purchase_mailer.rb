class PurchaseMailer < ApplicationMailer
  
  before_action do
    @user = params[:user] 
    @seller = params[:seller]
    @purchase = params[:purchase]
    @merchandise = params[:merchandise]
    @non_user_email = params[:non_user_email]
  end
  
  before_action :set_url

  before_action :create_subject, only: [:purchase_received, :donation_received]

  def purchase_saved
    create_recipient_saved
    mail(to: @recipient, subject: 'Your purchase has been confirmed')
  end

  def donation_saved
    create_recipient_saved
    mail(to: @recipient, subject: 'Your donation is appreciated')
  end

  def purchase_received
    mail(to: @seller.email, subject: "#{@buyer_name} has made a purchase")
  end

  def donation_received
    mail(to: @seller.email, subject: "#{@buyer_name} has made a donation")
  end

  private 

  def create_recipient_saved
    if @user.present?
      @recipient = @user.email
    else
      @recipient = @purchase.email
    end
  end

  def create_subject
    if @user.present? 
      @buyer_name = @user.name
    else 
      @buyer_name = @purchase.email
    end
  end

  def set_url
    @home_url = home_url(host: 'crowdpublish.TV')
    # if you need more url options you can use this method to expand
  end

end
