class Court < ActiveRecord::Base

	has_many :abonnements
	has_many :bookings

	validates :name, :presence => true

	after_validation :set_defaults

	private
		def set_defaults
			self.opened ||= true
		end

end