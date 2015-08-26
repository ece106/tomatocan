class User < ActiveRecord::Base
#  extend FriendlyId
#  friendly_id :permalink, use: :slugged
  attr_accessor :managestripeacnt, :stripeaccountid, :account, :countryofbank, :currency, 
  :bankaccountnumber, :countryoftax

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

  def retrieve_bank_account #is this used
    @account = Stripe::Account.retrieve(stripeid)
    @countryoftax = @account.country
  end

  def add_bank_account(currency, bankaccountnumber, routingnumber, countryofbank)
    puts currency
    puts bankaccountnumber
    puts routingnumber
    puts countryofbank
    puts "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"

    if @countryoftax == "CA"
      if currency == "CAD"
        countryofbank = "CA"
      end  
    elsif self.countryoftax == "US"
      currency = "USD"
      countryofbank = "US"
    elsif currency == "USD"
      countryofbank = "US"
    elsif currency == "GBP"
      countryofbank = "GB"
    elsif currency == "DKK"
      countryofbank = "DK"
    elsif currency == "NOK" 
      countryofbank = "NO"
    elsif currency == "SEK" 
      countryofbank = "SE"
    elsif self.countryoftax == "AU"
      currency = "AUD"
      countryofbank = "AU"
    end
    account = Stripe::Account.retrieve(self.stripeid)
    puts currency
    puts bankaccountnumber
    puts routingnumber
    puts countryofbank
    puts "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"
    temp = account.external_accounts.create(
      {
        :external_account => {
          :object => "bank_account",
          :country => "US", #countryofbank, 
          :currency => "USD", #currency, 
          :routing_number => routingnumber,
          :account_number => bankaccountnumber
        }
      }
    )
    puts temp.country
    puts "TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT"
    account.save
  end    

  private
  def assign_defaults_on_new_user
    self.author = 2 unless self.author
  end

end
