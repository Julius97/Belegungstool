class ClubController < ApplicationController

	before_action -> { check_session(true,true) }

	def index
		@clubs = Club.all
	end

    def show 
	    if params[:id]
	    	@club = Club.find_by_id params[:id]
	    else
	        redirect_to club_index_path
	    end
    end

    def new

    end

    def create
	    if !params[:name].blank?
	        name = params[:name]
	        Club.create :name => name
	    end
	    redirect_to club_index_path
    end

    def edit
	    if params[:id]
	        @club = Club.find_by_id params[:id]
	    else
	        redirect_to club_index_path
	    end
    end

    def update
        if !params[:name].blank? && !params[:club_id].blank?
        	name = params[:name]
      		Club.find_by_id(params[:club_id]).update_attributes :name => name
    	end
    	redirect_to club_path params[:club_id]
    end

    def destroy
	    if params[:id]
	        if Club.find_by_id params[:id]
	        	Club.find_by_id(params[:id]).destroy
	        end
	    end
	    redirect_to club_index_path
    end

end