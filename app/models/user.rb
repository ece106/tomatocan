class User < ApplicationRecord
# We really should have somehow combined several User and Group methods into some kind of StripeAccount model since they do the same thing
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
  has_many :timeslots, dependent: :destroy

#  has_many :groups, through: :agreements  # Do we need this

  # Active Relationships (A user following a user)
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id" #, dependent: :destroy (if a user is deleted, delete the relationship)
  # Passive Relationships (A user followed by a user)
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id" #, dependent: :destroy (if a user is deleted, delete the relationship)

  has_many :following, through: :active_relationships, source: :followed 
  has_many :followers, through: :passive_relationships, source: :follower

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable #, :validatable #:confirmable 
  mount_uploader :profilepic, ProfilepicUploader
  mount_uploader :bannerpic, BannerpicUploader

#  geocoded_by :address  #geocoder has become a piece of junk
#  reverse_geocoded_by :latitude, :longitude
#  after_validation :geocode, :if => :address_changed?
#  after_validation :reverse_geocode #, :if => :latitude_changed?

  # Other default devise modules available are:
  # :token_authenticatable, :confirmable, :lockable, :timeoutable, :validatable and :omniauthable
  scope :updated_at, -> { where(order: 'DESC') }
  after_initialize :assign_defaults_on_new_user, if: -> {new_record?}

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name,  presence: true, length: { maximum: 50 }
  validates :permalink, presence: true, length: { maximum: 20, message: "must be less than 20 characters" },
                        format:     { with: /\A[\w+]+\z/ },
                        uniqueness: { case_sensitive: false }
  validates_presence_of :password, :on=>:create
  validates_confirmation_of :password, :on=>:create
  validates_confirmation_of :password, on: :update, if: :password_changed?
  validates_length_of   :password, within:  Devise.password_length, allow_blank: true, :if => :password
  validates_format_of   :email, with: Devise.email_regexp, allow_blank: true, :if => :email_changed?
  validates :twitter, format: /\A[\w+]+\z/, allow_blank: true
  validates :videodesc1, length: { maximum: 255 }
  validates :videodesc2, length: { maximum: 255 }
  validates :videodesc3, length: { maximum: 255 }

  before_save { |user| user.permalink = permalink.downcase }
  before_save { |user| user.email = email.downcase }

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

  private
    def assign_defaults_on_new_user 
      self.author = "storyteller" unless self.author
    end

    def parse_youtube url
      regex = /(?:youtu.be\/|youtube.com\/watch\?v=|\/(?=p\/))([\w\/\-]+)/
      if url.match(regex)
        url.match(regex)[1]
      end
    end

end