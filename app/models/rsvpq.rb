class Rsvpq < ApplicationRecord
  belongs_to :user, :optional => true
  belongs_to :event
#  validates :user_id, presence: true
  validates :event_id, presence: true
  

  #taken from user.rb
  validates_format_of   :email, with: Devise.email_regexp, allow_blank: true, :if => :email_changed?
 

  #this is comment
  # validates :email, presence: true
  
  
  #validates :email, format: { with: Devise.email_regexp, message: "invalid email" }
#  validates_format_of :email, with: Devise.email_regexp 
# May want to validate email address by sending an email to it
end
