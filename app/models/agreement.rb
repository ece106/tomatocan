class Agreement < ActiveRecord::Base
  belongs_to :group
  belongs_to :project

  validates :project_id, presence: true
  validates :group_id, presence: true
end
