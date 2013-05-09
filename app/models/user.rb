class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :genre1, :genre2, :genre3, :twitter, :Ustreamvid, :Ustreamchat, :title, :blogurl, :profilepic, :profilepicurl

  has_secure_password

####  mount_uploader :profilepic, ProfilepicUploader

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

#  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }  # ,  :storage => :s3 }

  has_many :books, :dependent => :destroy

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true 


print "AAAAAAAAAAAAUTHOR model ENDSTUFF called"

  private
#22

print "AAAAAAAAAAAAUTHOR model REMEMBERTOKEN called"

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
