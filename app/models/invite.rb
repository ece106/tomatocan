class Invite  < ApplicationRecord

	validates :firstname, presence: true
	validates :lastname, presence: true
	
	validates_format_of   :email, with: Devise.email_regexp, allow_blank: true
	validates :email, presence: true

	validates :description, presence: true

end