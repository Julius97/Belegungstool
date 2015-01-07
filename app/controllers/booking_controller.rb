class BookingController < ApplicationController

	before_action -> { check_session(true,false) }

	def index
		if @current_user.admin_permissions	
			@bookings = Booking.all.order(:from_date).reverse
			@actual_bookings = []
			@bookings.each do |booking| 
				if booking.from_date >= DateTime.now  
					@actual_bookings << booking
				end
			end

			@archived_bookings = []
			@bookings.each do |booking|
				if booking.from_date < DateTime.now
					@archived_bookings << booking
				end
			end
		else
			@actual_bookings = []
			Booking.all.where(:user_id => @current_user.id).order(:from_date).each do |my_booking|
				if my_booking.from_date >= DateTime.now
					@actual_bookings << my_booking
				end
			end
		end
	end

	def show
		if params[:id]
			if @current_user.admin_permissions
      			@booking = Booking.find_by_id params[:id]
      		else
      			@booking = Booking.find_by_id params[:id]
      			if @booking.user_id != @current_user.id
      				redirect_to booking_index_path
      			end
      		end
	    else
	        redirect_to booking_index_path
	    end
	end

	def new

	end

	def create
		if !params[:user_id].blank? && !params[:court_id].blank? && !params[:at_day].blank? && !params[:at_month].blank? && !params[:at_year].blank? && !params[:at_hour].blank? && !params[:at_min].blank? && !params[:to_hour].blank? && !params[:to_min].blank?
			court_id = Court.find_by_id(params[:court_id]).id
			user_id = User.find_by_id(params[:user_id]).id
			from_date = DateTime.new(params[:at_year].to_i,params[:at_month].to_i,params[:at_day].to_i,params[:at_hour].to_i,params[:at_min].to_i,0,"+1")
			to_date = DateTime.new(params[:at_year].to_i,params[:at_month].to_i,params[:at_day].to_i,params[:to_hour].to_i,params[:to_min].to_i,0,"+1")
			if playing_time_is_valid(from_date,to_date)
				if playing_time_is_available_in_comparison_to_bookings(court_id,from_date,to_date)
					if playing_time_is_available_in_comparison_to_abonnements(from_date.to_date,to_date.to_date,from_date,to_date,from_date.wday,court_id)
						Booking.create :user_id => user_id, :court_id => court_id, :from_date => from_date, :to_date => to_date
					end
				end
			end
		end
		redirect_to booking_index_path
	end

	def edit
		if params[:id]
			if @current_user.admin_permissions
      			@booking = Booking.find_by_id params[:id]
      			if @booking.from_date < DateTime.now
      				redirect_to booking_path params[:id]
      			end
      		else
      			@booking = Booking.find_by_id params[:id]
      			if @booking.user_id != @current_user.id || @booking.from_date < DateTime.now
      				redirect_to booking_index_path
      			end
      		end
	    else
	        redirect_to booking_index_path
	    end
	end

	def update
		allowed_to_update = false
		if params[:booking_id]
			if @current_user.admin_permissions
				allowed_to_update = true
      		else
      			booking = Booking.find_by_id params[:id]
      			if booking.user_id == @current_user.id
      				if booking.from_date >= DateTime.now
 						allowed_to_update = true
      				end
      			end
      		end
    	end
    	if allowed_to_update
			if !params[:booking_id].blank? && !params[:user_id].blank? && !params[:user_id].blank? && !params[:at_day].blank? && !params[:at_month].blank? && !params[:at_year].blank? && !params[:at_hour].blank? && !params[:at_min].blank? && !params[:to_hour].blank? && !params[:to_min].blank?
				court_id = Court.find_by_id(params[:court_id]).id
				user_id = User.find_by_id(params[:user_id]).id
				from_date = DateTime.new(params[:at_year].to_i,params[:at_month].to_i,params[:at_day].to_i,params[:at_hour].to_i,params[:at_min].to_i,0,"+1")
				to_date = DateTime.new(params[:at_year].to_i,params[:at_month].to_i,params[:at_day].to_i,params[:to_hour].to_i,params[:to_min].to_i,0,"+1")
				if playing_time_is_valid(from_date,to_date)
					if playing_time_is_available_in_comparison_to_bookings(court_id,from_date,to_date)
						if playing_time_is_available_in_comparison_to_abonnements(from_date.to_date,to_date.to_date,from_date,to_date,from_date.wday,court_id)
							Booking.find_by_id(params[:booking_id]).update_attributes :user_id => user_id, :court_id => court_id, :from_date => from_date, :to_date => to_date
						end
					end
				end
			end
		end
		redirect_to booking_path params[:booking_id]
	end

	def destroy
		allowed_to_destroy = false
		if params[:id]
			if @current_user.admin_permissions
				allowed_to_destroy = true
      		else
      			booking = Booking.find_by_id params[:id]
      			if booking.user_id == @current_user.id
      				if booking.from_date >= DateTime.now
 						allowed_to_destroy = true
      				end
      			end
      		end
    	end
    	if allowed_to_destroy
			if params[:id]
		        if Booking.find_by_id params[:id]
		        	Booking.find_by_id(params[:id]).destroy
		        end
		    end
		end
	    redirect_to booking_index_path
	end

	def playing_time_is_valid(from_date,to_date)
		is_valid = false
		if from_date > DateTime.now
			if from_date < to_date
				is_valid = true
			end
		end
		return is_valid
	end

	def playing_time_is_available_in_comparison_to_bookings(court_id,from_date,to_date)
		is_available = true
		Booking.all.where(:court_id => court_id).each do |booking|
			if from_date < booking.to_date && to_date > booking.from_date
				is_available = false
				break
			end
		end
		return is_available
	end

	def playing_time_is_available_in_comparison_to_abonnements(from_date,to_date,playing_time_starts,playing_time_ends,playing_day,court_id)
		is_available = true
		playing_time_starts = playing_time_starts.strftime("%H:%M:0")
		playing_time_ends = playing_time_ends.strftime("%H:%M:0")
		Abonnement.all.where(:playing_day => playing_day,:court_id => court_id).each do |abonnement|
			if from_date <= abonnement.to_date && to_date >= abonnement.from_date
				if playing_time_starts < abonnement.playing_time_ends.strftime("%H:%M:0") && playing_time_ends > abonnement.playing_time_starts.strftime("%H:%M:0")
					is_available = false
					break
				end
			end
		end
		return is_available
	end

end