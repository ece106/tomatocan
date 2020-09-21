class Group < ApplicationRecord
  extend FriendlyId
  friendly_id :permalink, use: :slugged

  attr_accessor :monthperkinfo, :monthbookinfo, :incomeinfo, :salebyphase, :totalinfo

  before_save { |group| group.permalink = permalink.downcase }

  belongs_to :user
  has_many :agreements
#  has_many :users, through: :agreements  # We might need this

  mount_uploader :grouppic, GrouppicUploader

  validates :user_id, presence: true
  validates :name, presence: true
  validates :address, presence: true
  validates :grouptype, presence: true
  validates :permalink, presence: true, format: { with: /\A[\w+]+\z/ }, length: { maximum: 20 },
                uniqueness: { case_sensitive: false }

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
