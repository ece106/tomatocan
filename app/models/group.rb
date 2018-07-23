class Group < ApplicationRecord
  extend FriendlyId
  friendly_id :permalink, use: :slugged

  attr_accessor :managestripeacnt, :stripeaccountid, :account, :countryofbank, :currency, :countryoftax, 
  :bankaccountnumber, :monthperkinfo, :monthbookinfo, :incomeinfo, :salebyphase, :totalinfo

  before_save { |group| group.permalink = permalink.downcase }

  belongs_to :user
  has_many :agreements
  has_many :phases, through: :agreements

  mount_uploader :grouppic, GrouppicUploader

  validates :user_id, presence: true
  validates :name, presence: true
  validates :address, presence: true
  validates :grouptype, presence: true
  validates :permalink, presence: true, format: { with: /\A[\w+]+\z/ }, length: { maximum: 20 },
                uniqueness: { case_sensitive: false }

  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

  def create_stripe_acnt(countryoftax, accounttype, firstname, lastname, bizname, 
    birthday, birthmonth, birthyear, userip, email) 
    #called from controller, this creates a managed/custom acct for a group
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
          :delay_days => 7,
          :interval => "monthly",
          :monthly_anchor => 1
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

  def add_bank_account(currency, bankaccountnumber, routingnumber, countryofbank, line1,
                        line2, city, postalcode, state, ein, ssn) 
    # actual stripe acct object was created in group's stripe customer acct on the createstripeaccount page. Here they're just adding their bank account number
    account = Stripe::Account.retrieve(self.stripeid) 
    ca = "CA"
    cad = "CAD"
    us = "US"
    usd = "USD"
    at = "AT"
    be = "BE"
    ch = "CH"
    de = "DE"
    dk = "DK"
    es = "ES"
    fi = "FI"
    fr = "FR"
    gb = "GB"
    ie = "IE"
    it = "IT"
    lu = "LU"
    nl = "NL"
    no = "NO"
    se = "SE"
    eur = "EUR"
    if account.country == ca   #called from controller after create acct button clicked
      if currency == cad
        countryofbank = "CA"
      end  
    elsif account.country == us  #account.country is country of tax id
      currency = "USD"
      countryofbank = "US"      #we're creating a stripe obj (external acct) so we can add
    elsif currency == usd
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
    elsif countryofbank == at||be||ch||de||dk||es||fi||fr||gb||ie||it||lu||
                           nl||no||se
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
    line1, city, zip, state, ein, ssn4)
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
      account.legal_entity.address.zip = zip
    end  
    unless ein == "" || ein == nil
      account.legal_entity.business_tax_id = ein
    end  
    unless ssn4 == "" || ssn4 == nil
      account.legal_entity.ssn_last_4 = ssn4
    end  
    account.save
  end  

  def calcdashboard # this calc not relevant to groups
    self.incomeinfo = []
    if stripesignup.present?
      month = self.stripesignup
    else
      month = Time.now
    end  
    while month < Date.today + 1.month do
      monthsales = Purchase.where('extract(month from created_at) = ? AND extract(year from created_at) = ? 
        AND group_id = ?', month.strftime("%m"), month.strftime("%Y"), self.id)
      earnings = monthsales.sum(:groupcut)
      self.incomeinfo << {month: month.strftime("%B %Y"), monthtotal: earnings} 
      month = month + 1.month
    end

    self.totalinfo = []
    mysales = Purchase.where('purchases.group_id = ?', self.id).order("created_at DESC")
    mysales.each do |sale| 
      author = User.find(sale.author_id)
      merch = Merchandise.find(sale.merchandise_id)
      self.totalinfo << {author: author.name, itemsold: merch.name, groupcut:sale.groupcut, soldwhen: sale.created_at.to_date} 
    end
  end  
end
