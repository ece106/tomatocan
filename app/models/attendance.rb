class Attendance < ApplicationRecord

   #validates_uniqueness_of :user_id, scope: [:event_id] #the scope is needed so that the combinaation of user_id and event_id are not repeated
   validates :user_id, presence: true
   validates :time_in, presence: true

 end
