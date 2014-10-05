  class User < ActiveRecord::Base
    geocoded_by :address
    reverse_geocoded_by :latitude, :longitude
    after_validation :geocode, :if => :address_changed?
    after_validation :reverse_geocode, :if => :latitude_changed?
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable #, :validatable

  after_initialize :assign_defaults_on_new_user, if: 'new_record?'
  
  mount_uploader :profilepic, ProfilepicUploader

  before_save { |user| user.permalink = permalink.downcase }
  before_save { |user| user.email = email.downcase }

  has_many :books #, :dependent => :destroy
  has_many :reviews
  has_many :groups
  has_many :events
  has_many :purchases
  default_scope order: 'users.updated_at DESC'

#  validates_uniqueness_of    :email,     :case_sensitive => false, :allow_blank => true, :if => :email_changed?
  validates_format_of    :email,    :with  => Devise.email_regexp, :allow_blank => true, :if => :email_changed?
  validates_presence_of    :password, :on=>:create
  validates_confirmation_of    :password, :on=>:create
  validates_length_of    :password, :within => Devise.password_length, :allow_blank => true

  validates :permalink, presence: true, length: { maximum: 20 },
                    format:     { with: /\A[\w+]+\z/ },
                    uniqueness: { case_sensitive: false }
  validates :name, presence: true, length: { maximum: 50 }
#  validates :twitter, length: { maximum: 20 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence:   true,
#                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
#  validates :password, presence: true # :if => :should_validate_password?  # :on => :create
#  validates :password_confirmation, presence: true 

  def should_validate_password?  # I don't think this is used
    updating_password || new_record?
  end

  private
  def assign_defaults_on_new_user
    self.author = 2
  end

end
