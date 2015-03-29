class LessonCard < ActiveRecord::Base

	belongs_to :user

	validates :user_id, :presence => true
	validates :initially, :presence => true
	validates :remaining, :presence => true

end