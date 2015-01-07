class User < ActiveRecord::Base

	attr_accessor :password
	before_create :encrypt_password
	before_update :encrypt_password

	validates_confirmation_of :password

	has_many :abonnements, :dependent => :destroy
	has_many :bookings, :dependent => :destroy
	belongs_to :club

	validates :first_name, :presence => true
	validates :last_name, :presence => true
	validates :mail_address, :presence => true

	after_validation :set_defaults

	def self.authenticate(mail_address,password)
		user = find_by_mail_address mail_address
		if user && user.password_hash == BCrypt::Engine.hash_secret(password,user.password_salt)
			user
		else
			nil
		end
	end

	def encrypt_password
		if password.present?
			self.password_salt = BCrypt::Engine.generate_salt
			self.password_hash = BCrypt::Engine.hash_secret(password,password_salt)
		end
	end

	def name 
		self.first_name + " " + self.last_name
	end

	private
		def set_defaults
			self.admin_permissions ||= false
		end

end