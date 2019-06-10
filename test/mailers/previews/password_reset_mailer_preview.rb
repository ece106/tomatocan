# Preview all emails at http://localhost:3000/rails/mailers/password_reset_mailer
class PasswordResetMailerPreview < ActionMailer::Preview
  def password_reset
    PasswordResetMailer.with(user: User.first).password_reset
  end
end
