class PriceList < ActiveRecord::Base

	validates :price, :presence => true
	validates :lesson, :presence => true
	validates :from_time, :presence => true
	validates :to_time, :presence => true

end