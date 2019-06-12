# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  def welcome_email
    UserMailer.with(user: User.first).welcome_email(User.first)
  end

  def password_reset
    UserMailer.with(user: User.first).password_reset(User.first)
  end
end
