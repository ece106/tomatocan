
class User < ApplicationRecord
# We really should have somehow combined several User and Group methods into some kind of StripeAccount model since they do the same thing
  attr_accessor :managestripeacnt, :stripeaccountid, :account, :countryofbank, :currency, :countryoftax, 
  :bankaccountnumber, :monthperkinfo, :monthbookinfo, :incomeinfo, :salebyfiletype, :salebyperktype, :totalinfo, 
  :purchasesinfo

  has_many :books 
  has_many :movies 
  has_many :movieroles 
  has_many :reviews
  has_many :groups
  has_many :purchases
  has_many :rsvpqs
  has_many :events, :through => :rsvpqs
  has_many :phases 
  has_many :merchandises #,through => :projects #but merchandise doesnt have to belong to a project 

  # Active Relationships (A user following a user)
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id" #, dependent: :destroy (if a user is deleted, delete the relationship)
  # Passive Relationships (A user followed by a user)
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id" #, dependent: :destroy (if a user is deleted, delete the relationship)

  has_many :following, through: :active_relationships, source: :followed 
  has_many :followers, through: :passive_relationships, source: :follower

  # Helper methods for Relationships

  # Follow a user
  def follow(other_user)
    following << other_user
  end #End of "follow" method

  # Unfollow a user
  def unfollow(other_user)
    following.delete(other_user)
  end #End of the "unfollow" method

  # Is following a specific user
  def following?(other_user)
    following.include?(other_user)
  end #End of the "following?" method

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable #, :validatable, :confirmable 
  mount_uploader :profilepic, ProfilepicUploader
  mount_uploader :bannerpic, BannerpicUploader

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

  def create_stripe_acnt(countryoftax, accounttype, firstname, lastname, bizname, 
    birthday, birthmonth, birthyear, userip, email) 
    #called from controller, this creates a managed/custom acct for an author
    account = Stripe::Account.create(
      {
        :country => countryoftax, 
        :type => "custom",
        :email => email,
        :legal_entity => {
          :business_name => bizname,
          :type => accounttype,
          :first_name => firstname,
          :last_name => lastname,
          :dob => {
            :day => birthday,
            :month => birthmonth,
            :year => birthyear
          }
        } ,
        :payout_schedule => {
          :delay_days => 2,
          :interval => "monthly",
          :monthly_anchor => 12
        }
      }
    )  
    self.update_attribute(:stripeid, account.id )
    self.update_attribute(:stripesignup, Time.now )
    account = Stripe::Account.retrieve(self.stripeid) 
    account.tos_acceptance.ip = userip
    account.tos_acceptance.date = Time.now.to_i        
    account.save
  end

  def add_bank_account(currency, bankaccountnumber, routingnumber, countryofbank, line1,
                        line2, city, postalcode, state, ein, ssn) 
    # actual stripe acct object was created in group's stripe customer acct on the createstripeaccount page. Here they're just adding their bank account number
    account = Stripe::Account.retrieve(self.stripeid) 
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
    bankacct = account.external_accounts.create(
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
    account.legal_entity.business_tax_id = ein
    account.legal_entity.ssn_last_4 = ssn
    account.save
  end    

  def manage_account(line1, line2, city, zip, state )
    account = Stripe::Account.retrieve(self.stripeid) #acct tokens are user.stripeid
    unless line1 == ""
      account.legal_entity.address.line1 = line1
    end  
    unless line2 == ""
      account.legal_entity.address.line2 = line2
    end  
    unless city == ""
      account.legal_entity.address.city = city
    end  
    unless state == ""
      account.legal_entity.address.state = state
    end  
    unless zip == ""
      account.legal_entity.address.zip = zip
    end
    #should we auto update user's email here incase they changed their email in CrowdPublish.TV db?
    account.save
  end  

  def correct_errors(countryofbank, currency, routingnumber, bankaccountnumber, 
    countryoftax, bizname, accounttype, firstname, lastname, birthday, birthmonth, birthyear, 
    line1, city, zip, state, ein, ssn4, fullssn)
    account = Stripe::Account.retrieve(self.stripeid)
    unless countryofbank == "" || countryofbank == nil
      account.external_account.country = countryofbank
    end  
    unless currency == "" || currency == nil
      account.external_account.currency = currency
    end
    unless routingnumber == "" || routingnumber == nil
      account.external_account.routing_number = routingnumber
    end
    unless bankaccountnumber == "" || bankaccountnumber == nil
      account.external_account.bank_account = bankaccountnumber
    end

    unless countryoftax == "" || countryoftax == nil
      account.country = countryoftax
    end  
    unless bizname == "" || bizname == nil
      account.legal_entity.business_name = bizname
    end  
    unless accounttype == "" || accounttype == nil
      account.legal_entity.type = accounttype
    end  
    unless firstname == "" || firstname == nil
      account.legal_entity.first_name = firstname
    end
    unless lastname == "" || lastname == nil
      account.legal_entity.last_name = lastname
    end
    unless birthday == "" || birthday == nil
      account.legal_entity.dob.day = birthday
    end  
    unless birthmonth == "" || birthmonth == nil
      account.legal_entity.dob.month = birthmonth
    end  
    unless birthday == "" || birthday == nil
      account.legal_entity.dob.year = birthyear
    end  

    unless line1 == "" || line1 == nil
      account.legal_entity.address.line1 = line1
    end
    unless city == "" || city == nil
      account.legal_entity.address.city = city
    end  
    unless state == "" || state == nil
      account.legal_entity.address.state = state
    end  
    unless zip == "" || zip == nil
      account.legal_entity.address.postal_code = zip
    end  
    unless ein == "" || ein == nil
      account.legal_entity.business_tax_id = ein
    end
    unless ssn4 == "" || ssn4 == nil
      account.legal_entity.ssn_last_4 = ssn4
    end
    unless fullssn == "" || fullssn == nil
      account.legal_entity.personal_id_number = fullssn
    end
    account.save
  end  

  def approve_agreement(agreeid) 
    agreement = Agreement.find(agreeid)
    agreement.approved = DateTime.now
    agreement.save
  end  
  def decline_agreement(agreeid) 
    agreement = Agreement.find(agreeid)
    agreement.approved = DateTime.new(1)
    agreement.save
  end  
  def mark_fulfilled(purchid) 
    purchase = Purchase.find(purchid)
    purchase.fulfillstatus = "sent"
    purchase.save
  end  

  def get_youtube_id
    if self.youtube1.present?
      if self.youtube1.match(/youtube.com/) || self.youtube1.match(/youtu.be/)
        youtube1parsed = parse_youtube self.youtube1
        self.update_attribute(:youtube1, youtube1parsed)
      end
    end
    if self.youtube2.present?
      if self.youtube2.match(/youtube.com/) || self.youtube2.match(/youtu.be/)
        youtube2parsed = parse_youtube self.youtube2
        self.update_attribute(:youtube2, youtube2parsed)
      end
    end
    if self.youtube3.present?
      if self.youtube3.match(/youtube.com/) || self.youtube3.match(/youtu.be/)
        youtube3parsed = parse_youtube self.youtube3
        self.update_attribute(:youtube3, youtube3parsed)
      end
    end
  end  

  def calcdashboard # Poll users for desired metrics
    self.monthperkinfo = []
    self.incomeinfo = []
    if stripesignup.present?
      monthq = self.stripesignup
    else
      monthq = Time.now
    end  

    # how many items sold & revenue each month
    while monthq < Date.today + 1.month do
      monthsales = Purchase.where('extract(month from created_at) = ? AND extract(year from created_at) = ? 
        AND author_id = ?', monthq.strftime("%m"), monthq.strftime("%Y"), self.id)

#      monthsales = Purchase.where("strftime('%m', created_at) = ?", monthq.strftime("%m"))
# Don't know why this line doesn't work

      if monthsales.empty?
        monthperksales = 0
        perkearnings = 0
      else
        monthperksales = monthsales.where('merchandise_id IS NOT NULL')
        if monthperksales.empty?
          perkearnings = 0
        else
          perkearnings = monthperksales.sum(:authorcut)
        end
      end
      # total monthly revenue
      self.incomeinfo << {month: monthq.strftime("%B %Y"), monthtotal: perkearnings} 
      monthq = monthq + 1.month
    end

    #list of all sales since user stripeid 
      self.totalinfo = []
      mysales = Purchase.where('purchases.author_id = ?', self.id).order('created_at DESC')
      mysales.each do |sale| 
        if sale.book_id.present?
          booksold = Book.find(sale.book_id) 
          customer = User.find(sale.user_id) 
          self.totalinfo << {soldtitle: booksold.title, soldprice: sale.pricesold, authorcut:sale.authorcut, 
            purchaseid: sale.id, soldwhen: sale.created_at.to_date, whobought: customer.name, address: sale.shipaddress, 
            fulfillstat: sale.fulfillstatus, ebook: sale.bookfiletype } 
        elsif sale.merchandise_id.present?
          perksold = Merchandise.find(sale.merchandise_id) 
          customer = User.find(sale.user_id) 
          self.totalinfo << {soldtitle: perksold.name, soldprice: sale.pricesold, authorcut: sale.authorcut, 
            purchaseid: sale.id, soldwhen: sale.created_at.to_date, whobought: customer.name, address: sale.shipaddress, 
            fulfillstat: sale.fulfillstatus, ebook: "" } 
        end
      end
      # Place Campaigns supported on dashboard later
  end  

  private
    def assign_defaults_on_new_user 
      self.author = "author" unless self.author
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
