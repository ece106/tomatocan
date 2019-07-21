class UserMailer < ApplicationMailer
 
  before_action do
    @user = params[:user]
  end

  before_action :set_url

  def welcome_email
    mail(to: @user.email, subject: "Welcome")
  end
  
  private

  def set_url
    @home_url = home_url(host: 'crowdpublish.TV')
    # if you need more url options you can use this method to expand
  end

  
  def inline_images
    img_path ="app/assets/images/social-share-button"
    img_list = ['email.svg','facebook.svg','linkedin.svg','twitter.svg']
    img_list.each {|x| attachments.inline[x] = File.read("#{img_path}/#{x}")}
    attachments.inline['starIcon.png'] = File.read("app/assets/images/starIcon.png")
  end

end
