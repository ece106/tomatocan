# Preview all emails at http://localhost:3000/rails/mailers/delete_me_mailer
class DeleteMeMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/delete_me_mailer/delete_me_method
  def delete_me_method
    DeleteMeMailer.delete_me_method
  end

end
