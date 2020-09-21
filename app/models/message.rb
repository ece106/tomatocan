class Message  < ApplicationRecord

	validates :fullname, presence: true
	validates_format_of   :email, with: Devise.email_regexp, allow_blank: true
	validates :email, presence: true
	validates :subject, presence: true
	validates :message, presence: true

end