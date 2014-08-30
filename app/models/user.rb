  class User < ActiveRecord::Base
    geocoded_by :address
    reverse_geocoded_by :latitude, :longitude
    after_validation :geocode, :if => :address_changed?
    after_validation :reverse_geocode, :if => :latitude_changed?
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_initialize :assign_defaults_on_new_user, if: 'new_record?'
  
#  attr_accessible :permalink, :name, :email, :password, :about, :author, :password_confirmation, :remember_me, :genre1, :genre2, :genre3, :twitter, :ustreamvid, :ustreamsocial, :title, :blogurl, :profilepic, :profilepicurl, :youtube, :pinterest, :facebook

  mount_uploader :profilepic, ProfilepicUploader

  before_save { |user| user.permalink = permalink.downcase }
  before_save { |user| user.email = email.downcase }

#  before_save :create_remember_token
#  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }  # ,  :storage => :s3 }
#  has_secure_password

  has_many :books #, :dependent => :destroy
  has_many :reviews
  has_many :groups
  has_many :events
  has_many :purchases
  default_scope order: 'users.updated_at DESC'

  validates :permalink, presence: true, length: { maximum: 20 },
                    format:     { with: /\A[\w+]+\z/ },
                    uniqueness: { case_sensitive: false }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true # :if => :should_validate_password?  # :on => :create
#  validates :password, presence: true, length: { minimum: 6 }
#  devise now handles email validations
  validates :password_confirmation, presence: true 

#  def to_param
#    permalink
#  end

  def should_validate_password?
    updating_password || new_record?
  end

  private
  def assign_defaults_on_new_user
    self.author = 2
#    self.latitude = request.location.latitude
#    self.longitude = request.location.longitude
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
