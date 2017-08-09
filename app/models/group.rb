class Group < ActiveRecord::Base
  extend FriendlyId
  friendly_id :permalink, use: :slugged

  before_save { |group| group.permalink = permalink.downcase }

  belongs_to :user
  has_many :agreements
  has_many :projects, through: :agreements

  mount_uploader :grouppic, GrouppicUploader

  validates :user_id, presence: true
  validates :name, presence: true
  validates :address, presence: true
  validates :grouptype, presence: true
  validates :permalink, presence: true, format: { with: /\A[\w+]+\z/ }, length: { maximum: 20 },
                uniqueness: { case_sensitive: false }

  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

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

  def createstripeacnt(countryoftax, accounttype, firstname, lastname, birthday, birthmonth, birthyear, userip, email) 
    #called from controller, this creates a managed acct for an author
    account = Stripe::Account.create(
      {
        :country => countryoftax, 
        :managed => true,
        :email => email,
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
          :weekly_anchor => "monday"
        }
      }
    )  
    self.update_attribute(:stripeid, account.id )
    self.update_attribute(:stripesignup, Time.now )
    account = Stripe::Account.retrieve(self.stripeid) #do I need this
    account.tos_acceptance.ip = userip
    account.tos_acceptance.date = Time.now.to_i        
    account.save
  end

end
