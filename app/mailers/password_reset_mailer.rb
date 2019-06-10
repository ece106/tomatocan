class PasswordResetMailer < ApplicationMailer
  default from: "crowdpublishtv.star@gmail.com"

  def password_reset
    @user = User.find_by_reset_password_sent_at(Time.now.getutc)
    @url = edit_user_password_url(host: 'crowdpublish.TV')
    mail(to: @user.email, subject: "Password Reset With Crowdpublish.TV")
  end
end
