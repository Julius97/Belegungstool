class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  	private

	  	def check_session(nedds_login_check,needs_admin_permissions)
	  		if nedds_login_check
		  		if cookies.signed[:user_id]
				  	@current_user ||= User.find_by_id cookies.signed[:user_id]
				  	if @current_user
				  		if needs_admin_permissions
				  			if @current_user.admin_permissions
				  				set_up_profile_data
				  			else
				  				redirect_to home_index_path
				  			end
				  		else
				  			set_up_profile_data
				  		end
				  	else
				  		redirect_to logout_path
				  	end
				else
					redirect_to logout_path
				end
			else
				@current_user ||= User.find_by_id cookies.signed[:user_id] if cookies.signed[:user_id]
				if @current_user
					set_up_profile_data
				end
			end
	  	end

	  	def set_up_profile_data
	  		@my_bookings = []
	  		Booking.where(:user_id => @current_user.id).order(:from_date).each do |my_booking|
	  			if @my_bookings.count < 3
		  			if my_booking.from_date.to_date >= Date.today
		  				@my_bookings << my_booking
		  			end
		  		else 
		  			break
		  		end
	  		end

	  		@wday_array = ["Sonntags","Montags","Dienstags","Mittwochs","Donnerstags","Freitags","Samstags"]
	  		@my_abonnements = []
	  		Abonnement.where(:user_id => @current_user.id).order(:from_date).each do |my_abonnement|
	  			if @my_abonnements.count < 3
		  			if my_abonnement.to_date >= Date.today
		  				@my_abonnements << my_abonnement
		  			end
		  		else 
		  			break
		  		end
	  		end
	  	end

end
