class Booking < ActiveRecord::Base

	belongs_to :user
	belongs_to :court

	validates :user_id, :presence => true
	validates :court_id, :presence => true
	validates :from_date, :presence => true
	validates :to_date, :presence => true

end