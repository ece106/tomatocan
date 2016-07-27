class Merchandise < ActiveRecord::Base
  belongs_to :user # the project has user_id but merch doesn't have to be part of proj
  belongs_to :project
  has_many :purchases
end
