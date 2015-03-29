class AbonnementController < ApplicationController

	before_action -> { check_session(true,false) }

	def index
		if @current_user.admin_permissions
			@abonnements = Abonnement.all.order(:to_date).reverse
			@actual_abonnements = []
			@abonnements.each do |abonnement| 
				if abonnement.to_date >= Date.today  
					@actual_abonnements << abonnement
				end
			end

			@archived_abonnements = []
			@abonnements.each do |abonnement|
				if abonnement.to_date < Date.today
					@archived_abonnements << abonnement
				end
			end
		else
			@actual_abonnements = []
			Abonnement.all.where(:user_id => @current_user.id).order(:to_date).each do |my_abonnement|
				if my_abonnement.to_date >= Date.today
					@actual_abonnements << my_abonnement
				end
			end
		end
	end

	def show
		@wday_array = ["Sonntags","Montags","Dienstags","Mittwochs","Donnerstags","Freitags","Samstags"]
		if params[:id]
			if @current_user.admin_permissions
      			@abonnement = Abonnement.find_by_id params[:id]
      		else
      			@abonnement = Abonnement.find_by_id params[:id]
      			if @abonnement.user_id != @current_user.id
      				redirect_to abonnement_index_path
      			end
      		end
    	else
      		redirect_to abonnement_index_path
    	end
	end

	def new
		@wday_array = ["Sonntags","Montags","Dienstags","Mittwochs","Donnerstags","Freitags","Samstags"]
	end

	def create 
		if !params[:user_id].blank? && !params[:court_id].blank? && !params[:at_day].blank? && !params[:at_month].blank? && !params[:at_year].blank? && !params[:to_day].blank? && !params[:to_month].blank? && !params[:to_year].blank? && !params[:at_wday].blank? && !params[:at_hour].blank? && !params[:at_min].blank? && !params[:to_hour].blank? && !params[:to_min].blank?  
			from_date = Date.new(params[:at_year].to_i,params[:at_month].to_i,params[:at_day].to_i)
			to_date = Date.new(params[:to_year].to_i,params[:to_month].to_i,params[:to_day].to_i)
			playing_time_starts = DateTime.new(params[:at_year].to_i,params[:at_month].to_i,params[:at_day].to_i,params[:at_hour].to_i,params[:at_min].to_i,0)
			playing_time_ends = DateTime.new(params[:to_year].to_i,params[:to_month].to_i,params[:to_day].to_i,params[:to_hour].to_i,params[:to_min].to_i,0)
			if running_time_is_valid(from_date,to_date)
				if playing_time_is_valid(playing_time_starts.to_datetime,playing_time_ends.to_datetime)
					if abonnement_is_available(from_date,to_date,playing_time_starts,playing_time_ends,params[:at_wday].to_i,params[:court_id].to_i)
						Abonnement.create :user_id => params[:user_id], :court_id => params[:court_id], :from_date => from_date, :to_date => to_date, :playing_time_starts => playing_time_starts, :playing_time_ends => playing_time_ends, :playing_day => params[:at_wday] 
					end
				end
			end
		end
		redirect_to abonnement_index_path
	end

	def edit
		@wday_array = ["Sonntags","Montags","Dienstags","Mittwochs","Donnerstags","Freitags","Samstags"]
		if params[:id]
			if @current_user.admin_permissions
      			@abonnement = Abonnement.find_by_id params[:id]
      			if @abonnement.from_date < Date.today
      				redirect_to abonnement_path(params[:id])
      			end
      		else
      			@abonnement = Abonnement.find_by_id params[:id]
      			if @abonnement.user_id != @current_user.id ||  @abonnement.from_date < Date.today
      				redirect_to abonnement_index_path
      			end
      		end
    	else
      		redirect_to abonnement_index_path
    	end
	end

	def update
		allowed_to_update = false
		if params[:abonnement_id]
			if @current_user.admin_permissions
				if Abonnement.find_by_id(params[:abonnement_id]).from_date >= Date.today
					allowed_to_update = true
				end
      		else
      			abonnement = Abonnement.find_by_id params[:id]
      			if abonnement.user_id == @current_user.id
      				if abonnement.from_date >= Date.today
      					allowed_to_update = true
      				end
      			end
      		end
    	end
    	if allowed_to_update
			if !params[:abonnement_id].blank? && !params[:user_id].blank? && !params[:court_id].blank? && !params[:at_day].blank? && !params[:at_month].blank? && !params[:at_year].blank? && !params[:to_day].blank? && !params[:to_month].blank? && !params[:to_year].blank? && !params[:at_wday].blank? && !params[:at_hour].blank? && !params[:at_min].blank? && !params[:to_hour].blank? && !params[:to_min].blank?  
				from_date = Date.new(params[:at_year].to_i,params[:at_month].to_i,params[:at_day].to_i)
				to_date = Date.new(params[:to_year].to_i,params[:to_month].to_i,params[:to_day].to_i)
				playing_time_starts = DateTime.new(params[:at_year].to_i,params[:at_month].to_i,params[:at_day].to_i,params[:at_hour].to_i,params[:at_min].to_i,0)
				playing_time_ends = DateTime.new(params[:to_year].to_i,params[:to_month].to_i,params[:to_day].to_i,params[:to_hour].to_i,params[:to_min].to_i,0)
				if running_time_is_valid(from_date,to_date)
					if playing_time_is_valid(playing_time_starts,playing_time_ends)
						if abonnement_is_available(from_date,to_date,playing_time_starts,playing_time_ends,params[:at_wday].to_i,params[:court_id].to_i)
							Abonnement.find_by_id(params[:abonnement_id]).update_attributes :user_id => params[:user_id], :court_id => params[:court_id], :from_date => from_date, :to_date => to_date, :playing_time_starts => playing_time_starts, :playing_time_ends => playing_time_ends, :playing_day => params[:at_wday] 
						end
					end
				end
			end
		end
		redirect_to abonnement_path params[:abonnement_id]
	end

	def destroy
		allowed_to_destroy = false
		if params[:id]
			if @current_user.admin_permissions
				if Abonnement.find_by_id(params[:id]).from_date >= Date.today
					allowed_to_destroy = true
				end
      		else
      			abonnement = Abonnement.find_by_id params[:id]
      			if abonnement.user_id == @current_user.id
      				if abonnement.from_date >= Date.today
      					allowed_to_destroy = true
      				end
      			end
      		end
    	end
    	if allowed_to_destroy
			if params[:id]
		        if Abonnement.find_by_id params[:id]
		        	Abonnement.find_by_id(params[:id]).destroy
		        end
		    end
		end
	    redirect_to abonnement_index_path
	end

	def playing_time_is_valid(from_date,to_date)
		is_valid = false
		if from_date > DateTime.now
			from_date = from_date.strftime("%H:%M:0")
			to_date = to_date.strftime("%H:%M:0")
			if from_date < to_date
				is_valid = true
			end
		end
		return is_valid
	end

	def running_time_is_valid(from_date,to_date)
		is_valid = false
		if from_date > Date.today
			if from_date < to_date
				is_valid = true
			end
		end
		return is_valid
	end

	def abonnement_is_available(from_date,to_date,playing_time_starts,playing_time_ends,playing_day,court_id)
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