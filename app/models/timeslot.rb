class Timeslot < ApplicationRecord
	
	belongs_to :user
	#has_many :events

#	validate :endat_greaterthan_startat 
	validates :user_id, presence: true
	validates :start_at, presence: true
	validates :end_at, presence: true

	# def endat_greaterthan_startat
	# 	if end_at.present? && end_at < start_at
	#  		errors.add(:end_at, "End time must be after start time")
	# 	end
	# end  




end
