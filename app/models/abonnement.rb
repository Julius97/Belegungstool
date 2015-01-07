class Abonnement < ActiveRecord::Base

	belongs_to :court
	belongs_to :user

	validates :user_id, :presence => true
	validates :court_id, :presence => true
	validates :from_date, :presence => true
	validates :to_date, :presence => true
	validates :playing_time_starts, :presence => true
	validates :playing_time_ends, :presence => true
	validates :playing_day, :presence => true

	def get_playing_day_name(playing_day_index)
		wday_array = ["Montags","Dienstags","Mittwochs","Donnerstags","Freitags","Samstags","Sonntags"]
		return wday_array[playing_day_index-1]
	end

end