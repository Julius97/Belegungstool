class HomeController < ApplicationController

	before_action -> { check_session(false,false) }

	def index
		@courts = Court.all.where(:opened => true).order :name

		@booking_date = Date.today
		@booking_date = Date.new(@booking_date.year,@booking_date.month,@booking_date.day)
		@bookings = []
		@abonnements = []
		if !params[:at_day].blank? && !params[:at_month].blank? && !params[:at_day].blank?
			@booking_date = Date.new(params[:at_year].to_i,params[:at_month].to_i,params[:at_day].to_i)
		end

		Booking.all.order(:from_date,:court_id).each do |booking|
			if booking.from_date.to_date == @booking_date
				@bookings << booking
			end
		end

		Abonnement.all.order(:from_date,:court_id).each do |abonnement|
			if @booking_date.wday == abonnement.playing_day
				if (abonnement.from_date..abonnement.to_date).include?(@booking_date)
					@abonnements << abonnement
				end

			end
		end

		@bookings_sorted_by_hours = Array.new(24){Array.new(3)}
		i=0
		24.times do 
			k = 0
			3.times do
				@bookings_sorted_by_hours[i][k] = "Frei"
				k += 1
			end
			i += 1
		end

		i = 0
		24.times do 
			@bookings.each do |booking|
				court_index = @courts.index booking.court
				if DateTime.new(@booking_date.year,@booking_date.month,@booking_date.day,i,0,0,"+1") < booking.to_date && DateTime.new(@booking_date.year,@booking_date.month,@booking_date.day,i+1,0,0,"+1") > booking.from_date
	    			@bookings_sorted_by_hours[i][court_index] = booking.user.name
	    		end
	    	end
	    	i += 1
    	end

    	i = 0
		24.times do 
			Abonnement.all.each do |abonnement|
				court_index = @courts.index abonnement.court
				if Date.new(@booking_date.year,@booking_date.month,@booking_date.day).wday.to_i == abonnement.playing_day
		    		if (abonnement.from_date..abonnement.to_date).include?(Date.new(@booking_date.year,@booking_date.month,@booking_date.day))
		    			playing_time_starts = DateTime.new(@booking_date.year,@booking_date.month,@booking_date.day,i,0,0,"+1").strftime("%H:%M:0")
						playing_time_ends = DateTime.new(@booking_date.year,@booking_date.month,@booking_date.day,i+1,0,0,"+1").strftime("%H:%M:0")
		    			if playing_time_starts < abonnement.playing_time_ends.strftime("%H:%M:0") && playing_time_ends > abonnement.playing_time_starts.strftime("%H:%M:0")
		    				@bookings_sorted_by_hours[i][court_index] = "Abo: " + abonnement.user.name
		    			end
	    			end
	    		end
	    	end
	    	i += 1
    	end
    end

end
