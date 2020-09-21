class User < ApplicationRecord

  attr_accessor :monthperkinfo, :monthbookinfo, :incomeinfo, :salebyfiletype, :salebyperktype, :totalinfo,
  :purchasesinfo, :on_password_reset

  has_many :books
  has_many :movies
  has_many :movieroles
  has_many :reviews
#  has_many :groups
  has_many :purchases
  has_many :rsvpqs
  has_many :events, :through => :rsvpqs
  has_many :merchandises

  # Active Relationships (A user following a user)
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id" #, dependent: :destroy (if a user is deleted, delete the relationship)
  # Passive Relationships (A user followed by a user)
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id" #, dependent: :destroy (if a user is deleted, delete the relationship)

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]#:confirmable 
  mount_uploader :profilepic, ProfilepicUploader
  mount_uploader :bannerpic, BannerpicUploader

  # Other default devise modules available are:
  # :token_authenticatable, :confirmable, :lockable, :timeoutable, :validatable and :omniauthable
  scope :updated_at, -> { where(order: 'DESC') }
  after_initialize :assign_defaults_on_new_user, if: -> {new_record?}

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name,  presence: true, length: { maximum: 50 }
  validates :permalink, presence: true, length: { maximum: 20, message: "must be less than 20 characters" },
                        format:     { with: /\A[\w+]+\z/ , message: "should be alphanumeric"},
                        uniqueness: { case_sensitive: false, message: "is not available"}
  validates_presence_of :password, :on=>:create
  validates_confirmation_of :password, :on=>:create
  validates_confirmation_of :password, on: :update, if: :password_changed?
  validates_length_of   :password, within:  Devise.password_length, allow_blank: true, :if => :password
  validates_format_of   :email, with: Devise.email_regexp, allow_blank: true, :if => :email_changed?
  validates :twitter, format: /\A[\w+]+\z/, allow_blank: true

  before_save { |user| user.permalink = permalink.downcase }
  before_save { |user| user.email = email.downcase }

  # Helper methods for Relationships

  def authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user.try(:valid_password?, password) ? user : nil
  end

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

  def password_changed?
    !password.blank?
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

  def calcdashboard # Poll users for desired metrics
    self.monthperkinfo = []
    self.incomeinfo = []
      monthq = self.created_at  # self.stripesignup

    # how many items sold & revenue each month
    while monthq < Date.today + 1.month do
      monthsales = Purchase.where('extract(month from created_at) = ? AND extract(year from created_at) = ?
        AND author_id = ?', monthq.strftime("%m"), monthq.strftime("%Y"), self.id)

      # monthsales = Purchase.where("strftime('%m', created_at) = ?", monthq.strftime("%m"))
      # Don't know why this line doesn't work

      monthperksales = monthsales.where('merchandise_id IS NOT NULL')
      #perkearnings = monthperksales.sum(:authorcut)
      # total monthly revenue
      #self.incomeinfo << {month: monthq.strftime("%B %Y"), monthtotal: perkearnings}
      monthq = monthq + 1.month
    end

    #list of all sales since user stripeid
      self.totalinfo = []
      mysales = Purchase.where('purchases.author_id = ?', self.id).order('created_at DESC')
      mysales.each do |sale|
        if (!sale.merchandise_id.nil?)
          perksold = Merchandise.find(sale.merchandise_id)
          purchaseName = perksold.name
        else
          purchaseName = 'Donation'
        end
        if sale.user_id.present?
          customer = User.find(sale.user_id)
          whobought = customer.name
        else
          whobought = "anonymous"
        end
        self.totalinfo << {soldtitle: purchaseName, soldprice: sale.pricesold, authorcut: sale.authorcut,
            purchaseid: sale.id, soldwhen: sale.created_at.to_date, whobought: whobought, address: sale.shipaddress,
            fulfillstat: sale.fulfillstatus, egoods: "" }
      end
      # Place Campaigns supported on dashboard later
  end


  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      elsif data = session["devise.google_data"] && session["devise.google_data"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.permalink = auth.info.name.delete(' ') + rand.to_s[2..6]
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.profilepic = auth.info.image # assuming the user model has an image
    end
  end

  private
    def assign_defaults_on_new_user
      self.author = "storyteller" unless self.author
    end

end
