class UserMailer < ApplicationMailer

  before_action do
    @user = params[:user]
  end

  before_action :set_url

  def welcome_email
    inline_images
    mail(to: @user.email, subject: "Welcome")
  end

  private

  def set_url
    @home_url = home_url(host: 'ThinQ.tv')
    # if you need more url options you can use this method to expand
  end


  def inline_images
    img_path ="app/assets/images/social-share-button"
    img_path_two = "app/assets/images"
    img_list = ['email.png','facebook.png','linkedin.png','twitter.png']
    img_list_two = ["laptop.png"]
    img_list.each {|x| attachments.inline[x] = File.read("#{img_path}/#{x}")}
    img_list_two.each {|a| attachments.inline[a] = File.read("#{img_path_two}/#{a}")}
  end

end
