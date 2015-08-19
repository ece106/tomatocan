class User < ActiveRecord::Base
#  extend FriendlyId
#  friendly_id :permalink, use: :slugged
  attr_accessor :countryofbank, :managestripeacnt, :first_name, :stripeaccountid, :countryofaccount,
  :firstname, :lastname, :birthmonth, :birthday, :birthyear, :accounttype, :mailaddress, :ssn

  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode, :if => :address_changed?
  after_validation :reverse_geocode, :if => :latitude_changed?
  # Other default devise modules available are:
  # :token_authenticatable, :confirmable, :lockable, :timeoutable, :validatable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable 

  after_initialize :assign_defaults_on_new_user, if: 'new_record?'
  
  mount_uploader :profilepic, ProfilepicUploader

  before_save { |user| user.permalink = permalink.downcase }
  before_save { |user| user.email = email.downcase }

  has_many :books 
  has_many :reviews
  has_many :groups
#  has_many :events
  has_many :purchases
  has_many :rsvps
  has_many :events, :through => :rsvps
  default_scope order: 'users.updated_at DESC'

  validates_format_of    :email,    :with  => Devise.email_regexp, :allow_blank => true, :if => :email_changed?
  validates_presence_of    :password, :on=>:create
  validates_confirmation_of    :password, :on=>:create
  validates_length_of    :password, :within => Devise.password_length, :allow_blank => true

  validates :permalink, presence: true, length: { maximum: 20, message: "must be less than 20 characters" },
                    format:     { with: /\A[\w+]+\z/ },
                    uniqueness: { case_sensitive: false }
  validates :name, presence: true, length: { maximum: 50 }
#  validates :twitter, length: { maximum: 20 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :videodesc1, length: { maximum: 255 }
  validates :videodesc2, length: { maximum: 255 }
  validates :videodesc3, length: { maximum: 255 }

  validates :email, presence:   true,
                    uniqueness: { case_sensitive: false }

  def create_bank_account
    puts self.accounttype + "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"
    puts @lastname + "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"
    stripeaccount = Stripe::Account.create(
      {
        :country => self.countryofbank, # @country #should be selected from a dropdown box
        :managed => true,
        :email => self.email,
# legal_entity.dob.day, legal_entity.dob.month, legal_entity.dob.year, legal_entity.type, legal_entity.address.line1, legal_entity.address.city, legal_entity.address.postal_code, bank_account, tos_acceptance.ip, tos_acceptance.date
        :legal_entity => {
          :type => self.accounttype,
          :last_name => self.lastname
        }
      }
    )  
    stripeaccount.legal_entity = 
      {:first_name => self.firstname, :last_name => self.lastname}
    
    @stripeaccountid = stripeaccount.id 
 #   stripeaccount.save
  end

  def retrieve_bank_account
    @account = Stripe::Account.retrieve(stripeid)
    @countryofaccount = @account.country
  end

  def save_bank_account
    #account = 
    #use fields_needed hash for 
    puts @firstname + "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"
    self.account.save(
      {
        :first_name => @firstname,
        :last_name => @lastname
      }
    )  
  end

  private
  def assign_defaults_on_new_user
    self.author = 2 unless self.author
  end

end
