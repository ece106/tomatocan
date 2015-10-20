class User < ActiveRecord::Base
#  extend FriendlyId
#  friendly_id :permalink, use: :slugged
  attr_accessor :managestripeacnt, :stripeaccountid, :account, :countryofbank, :currency, 
  :bankaccountnumber

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
  has_many :rsvpqs
  has_many :events, :through => :rsvpqs
#  default_scope order: 'users.updated_at DESC'
  scope :updated_at, -> { where(order: 'DESC') }

  validates_format_of    :email,    :with  => Devise.email_regexp, :allow_blank => true, :if => :email_changed?
  validates_presence_of    :password, :on=>:create
  validates_confirmation_of    :password, :on=>:create
  validates_presence_of :password_confirmation, :on => :update, :unless => lambda{ |user| user.password.blank? }
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

  def add_bank_account(countryoftax, currency, bankaccountnumber, routingnumber, countryofbank)
    if countryoftax == "CA"
      if currency == "CAD"
        countryofbank = "CA"
      end  
    elsif countryoftax == "US"
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
    elsif countryoftax == "AU"
      currency = "AUD"
      countryofbank = "AU"
    end
    account = Stripe::Account.retrieve(self.stripeid)
    temp = account.external_accounts.create(
      {
        :external_account => {
          :object => "bank_account",
          :country => countryofbank, 
          :currency => currency, 
          :routing_number => routingnumber,
          :account_number => bankaccountnumber
        }
      }
    )
    puts temp.country
    puts temp.currency
    puts temp.routing_number
    puts temp.account #might want to save account token in users hasmany accounts table so I can access later
    account.save
  end    

  def parse_ustreamyoutube
      if self.ustreamvid.match(/ustream.tv\/embed/)
        ustreamparsed = parse_ustream self.ustreamvid
        self.update_attribute(:ustreamvid, ustreamparsed)
      end
    if self.youtube1 #I don't think I need this
      if self.youtube1.match(/youtube.com/) || self.youtube1.match(/youtu.be/)
        youtube1parsed = parse_youtube self.youtube1
        self.update_attribute(:youtube1, youtube1parsed)
      end
    end
    if self.youtube2 
      if self.youtube2.match(/youtube.com/) || self.youtube2.match(/youtu.be/)
        youtube2parsed = parse_youtube self.youtube2
        self.update_attribute(:youtube2, youtube2parsed)
      end
    end
    if self.youtube3
      if self.youtube3.match(/youtube.com/) || self.youtube3.match(/youtu.be/)
        youtube3parsed = parse_youtube self.youtube3
        self.update_attribute(:youtube3, youtube3parsed)
      end
    end
  end  

  private
  def assign_defaults_on_new_user
    self.author = 2 unless self.author
  end

    def parse_youtube url
      regex = /(?:youtu.be\/|youtube.com\/watch\?v=|\/(?=p\/))([\w\/\-]+)/
      if url.match(regex)
        url.match(regex)[1]
      end
    end

    def parse_ustream url
      regex = /(?:.be\/|ustream.tv\/embed\/|\/(?=p\/))([\w\/\-]+)/
      if url.match(regex)
        url.match(regex)[1]
      end
    end


end
