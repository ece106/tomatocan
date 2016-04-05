class User < ActiveRecord::Base
#  extend FriendlyId
#  friendly_id :permalink, use: :slugged
  attr_accessor :managestripeacnt, :stripeaccountid, :account, :countryofbank, :currency, 
  :countryoftax, :bankaccountnumber, :monthinfo, :incomeinfo, :filetypeinfo, :totalinfo, 
  :purchasesinfo

  has_many :books 
  has_many :reviews
  has_many :groups
  has_many :purchases
  has_many :rsvpqs
  has_many :events, :through => :rsvpqs

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable 
  mount_uploader :profilepic, ProfilepicUploader

  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude
  after_validation :geocode, :if => :address_changed?
  after_validation :reverse_geocode #, :if => :latitude_changed?
  # Other default devise modules available are:
  # :token_authenticatable, :confirmable, :lockable, :timeoutable, :validatable and :omniauthable
  scope :updated_at, -> { where(order: 'DESC') }
  after_initialize :assign_defaults_on_new_user, if: 'new_record?'

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false }
  validates :name,  presence: true, length: { maximum: 50 }
  validates :permalink, presence: true, length: { maximum: 20, message: "must be less than 20 characters" },
                        format:     { with: /\A[\w+]+\z/ },
                        uniqueness: { case_sensitive: false }
  validates_presence_of :password, :on=>:create
  validates_presence_of :password_confirmation, :on => :update, :unless => lambda{ |user| user.password.blank? }
  validates_confirmation_of :password, :on=>:create
  validates_length_of   :password, :within => Devise.password_length, :allow_blank => true
  validates_format_of   :email, :with  => Devise.email_regexp, 
                                :allow_blank => true, :if => :email_changed?
#  validates :twitter, length: { maximum: 20 }
  validates :videodesc1, length: { maximum: 255 }
  validates :videodesc2, length: { maximum: 255 }
  validates :videodesc3, length: { maximum: 255 }

  before_save { |user| user.permalink = permalink.downcase }
  before_save { |user| user.email = email.downcase }

  def add_bank_account(currency, bankaccountnumber, routingnumber, countryofbank, line1,
                        line2, city, postalcode, state)
    account = Stripe::Account.retrieve(self.stripeid) #acct tokens are user.stripeid
    if account.country == "CA"   #called from controller after create acct button clicked
      if currency == "CAD"
        countryofbank = "CA"
      end  
    elsif account.country == "US"  #account.country is country of tax id
      currency = "USD"
      countryofbank = "US"      #we're creating a stripe obj (external acct) so we can add
    elsif currency == "USD"
      countryofbank = "US"      #financial institution bank acct to a stripe managed account
    elsif currency == "GBP"
      countryofbank = "GB"
    elsif currency == "DKK"
      countryofbank = "DK"
    elsif currency == "NOK" 
      countryofbank = "NO"
    elsif currency == "SEK"   
      countryofbank = "SE"
    elsif account.country == "AU"
      currency = "AUD"
      countryofbank = "AU"
    elsif countryofbank == "AT"||"BE"||"CH"||"DE"||"DK"||"ES"||"FI"||"FR"||"GB"||"IE"||"IT"||"LU"||
                           "NL"||"NO"||"SE"
      currency = "EUR"
    end
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
    #is there a reason why I'm not adding these lines to external_accts.create
    account.legal_entity.address.line1 = line1
    unless line2 == ""
      account.legal_entity.address.line2 = line2
    end  
    account.legal_entity.address.city = city
    account.legal_entity.address.postal_code = postalcode
#if CA, US
    account.legal_entity.address.state = state
    account.save

    puts temp.currency
    puts countryofbank
    puts temp.account #might want to save account token in users hasmany accounts table so I can access later
  end    

  def createstripeacnt(countryoftax, accounttype, firstname, lastname, birthday, birthmonth, birthyear, userip) 
    #called from controller, this creates a managed acct for an author
    account = Stripe::Account.create(
      {
        :country => countryoftax, 
        :managed => true,
        :email => self.email,
        :legal_entity => {
          :type => accounttype,
          :first_name => firstname,
          :last_name => lastname,
          :dob => {
            :day => birthday,
            :month => birthmonth,
            :year => birthyear
          }
        } ,
        :transfer_schedule => {
          :delay_days => 2,
          :interval => "weekly",
          :weekly_anchor => "Monday"
        }
      }
    )  
    self.update_attribute(:stripeid, account.id )
    account = Stripe::Account.retrieve(self.stripeid) #do I need this
    account.tos_acceptance.ip = userip
    account.tos_acceptance.date = Time.now.to_i        
    account.save
  end

  def get_youtube_id
      if self.youtube1.match(/youtube.com/) || self.youtube1.match(/youtu.be/)
        youtube1parsed = parse_youtube self.youtube1
        self.update_attribute(:youtube1, youtube1parsed)
      end
      if self.youtube2.match(/youtube.com/) || self.youtube2.match(/youtu.be/)
        youtube2parsed = parse_youtube self.youtube2
        self.update_attribute(:youtube2, youtube2parsed)
      end
      if self.youtube3.match(/youtube.com/) || self.youtube3.match(/youtu.be/)
        youtube3parsed = parse_youtube self.youtube3
        self.update_attribute(:youtube3, youtube3parsed)
      end
  end  

  def calcdashboard(usr) # dashboard currently only shows ebook sales info. Poll users for metrics later
    self.monthinfo = []
    self.incomeinfo = []
    month = usr.created_at
    while month < Date.today do
      monthsales = Purchase.where('extract(month from created_at) = ? AND extract(year from created_at) = ? 
        AND author_id = ?', month.strftime("%m"), month.strftime("%Y"), usr.id)
      booksales = monthsales.group(:book_id)
      counthash = booksales.count
      earningshash = booksales.sum(:authorcut)
      for bookid, countsold in counthash
        book = Book.find(bookid)
        self.monthinfo <<  {month: month.strftime("%B %Y"), monthtitle: book.title, monthquant: countsold, 
          monthearnings: earningshash[bookid]} 
      end
      earnings = monthsales.sum(:authorcut)
      self.incomeinfo <<  {month: month.strftime("%B %Y"), monthtotal: earnings} 
      month = month + 1.month
    end

    self.filetypeinfo = []
    mysales = Purchase.where('purchases.author_id = ?', usr.id)
    titlegroup = mysales.group(:book_id, :bookfiletype)
    counthash = titlegroup.count
    for bookidfiletype, counttype in counthash
      book = Book.find(bookidfiletype[0])
      self.filetypeinfo << {title: book.title, filetype: bookidfiletype[1], quantity: counttype} 
    end

    self.totalinfo = []
    mysales = Purchase.where('purchases.author_id = ?', usr.id)
    mysales.each do |sale| 
      booksold = Book.find(sale.book_id) 
      customer = User.find(sale.user_id) 
      self.totalinfo << {soldtitle: booksold.title, soldprice: sale.pricesold, authorcut:sale.authorcut, soldwhen: sale.created_at.to_date, whobought: customer.name} 
    end

    mypurchases = usr.purchases
    self.purchasesinfo = []
    mypurchases.each do |bought| 
      bookbought = Book.find(bought.book_id) 
      author = User.find(bookbought.user_id) 
      self.purchasesinfo << {purchasetitle: bookbought.title, purchaseauthor: author.name, purchaseprice: bought.pricesold, purchasedwhen: bought.created_at.to_date} 
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

    def parse_ustream url #i believe this is no longer used
      regex = /(?:ustream.tv\/embed\/|\/(?=p\/))([\w\/\-]+)/
      if url.match(regex)
        url.match(regex)[1]
      end
    end

end
