class Timeslot < ApplicationRecord
	
	belongs_to :user

#	validate :endat_greaterthan_startat 
	validates :user_id, presence: true



	# def endat_greaterthan_startat
	# 	if end_at.present? && end_at < start_at
	#  		errors.add(:end_at, "End time must be after start time")
	# 	end
	# end  




end
