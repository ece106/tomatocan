class DeleteMeMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.delete_me_mailer.delete_me_method.subject
  #
  def delete_me_method
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
