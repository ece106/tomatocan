class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_initialize :assign_defaults_on_new_User, if: 'new_record?'
  
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :genre1, :genre2, :genre3, :twitter, :ustreamvid, :ustreamsocial, :title, :blogurl, :profilepic, :profilepicurl

#  has_secure_password

####  mount_uploader :profilepic, ProfilepicUploader

  before_save { |user| user.email = email.downcase }
#  before_save :create_remember_token

#  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }  # ,  :storage => :s3 }

  has_many :books, :dependent => :destroy
  has_many :reviews

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true
#  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true 

  private
  def assign_defaults_on_new_User
    self.ustreamsocial = '<iframe width="468" scrolling="no" height="586" frameborder="0" style="border: 0px none transparent;" src="http://www.ustream.tv/socialstream/13434383"></iframe>'
    self.ustreamvid = '<iframe src="http://www.ustream.tv/embed/13434383" width="608" height="368" scrolling="no" frameborder="0" style="border: 0px none transparent;"></iframe><br /><a href="http://www.ustream.tv/producer?utm_campaign=Embed+Producer+Promotion&utm_source=Web&utm_medium=Embed&utm_term=Producer+Page&utm_utm_content=Free+desktop+streaming+application+by+Ustream" style="padding: 2px 0px 4px; width: 400px; background: #ffffff; display: block; color: #000000; font-weight: normal; font-size: 10px; text-decoration: underline; text-align: center;" target="_blank">Free desktop streaming application by Ustream</a>'
  end

#  def authenticate(email, password)
#    if user = find_by_email(email)
#      if user.password == encrypt_password(password, user.salt)
#        user
#      end
#    end
#  end

#    def create_remember_token
#      self.remember_token = SecureRandom.urlsafe_base64
#    end

end
