class Agreement < ActiveRecord::Base
  belongs_to :group
  belongs_to :phase

  validates :phase_id, presence: true
  validates :group_id, presence: true
  validates :phase_id, uniqueness: {scope: :group_id,
   message: 'This group has already requested to affiliate with this project phase.' }
end
