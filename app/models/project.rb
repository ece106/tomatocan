class Project < ActiveRecord::Base
  extend FriendlyId
  friendly_id :permalink, use: :slugged

  before_save { |project| project.permalink = permalink.downcase }

  has_many :merchandises 
  belongs_to :user
  has_many :agreements
  has_many :groups, through: :agreements
  
  validates :user_id, presence: true
  validates :name, presence: true
  validates :permalink, presence: true, format: { with: /\A[\w+]+\z/ }, length: { maximum: 20 },
                uniqueness: { case_sensitive: false }

  before_save { |project| project.permalink = permalink.downcase }
end
