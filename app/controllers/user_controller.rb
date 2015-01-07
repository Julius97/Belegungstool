class UserController < ApplicationController

	before_action -> { check_session(true,false) }

	def index
		if @current_user.admin_permissions
			@users = User.all.order(:last_name)
		else
			redirect_to home_index_path
		end
	end

	def show
		if @current_user.admin_permissions
			if params[:id]
	      		@user = User.find_by_id params[:id]
	    	else
	      		redirect_to user_index_path
	    	end
	    else
			redirect_to home_index_path
		end
	end

	def new
		if !@current_user.admin_permissions
			redirect_to home_index_path
		end
	end

	def create
		if @current_user.admin_permissions
			if !params[:first_name].blank? && !params[:last_name].blank? && !params[:mail].blank?
				admin_permissions = false
			    if !params[:admin_permissions].nil?
			        admin_permissions = true
			    end
			    if !params[:club_id].blank?
			    	club_id = Club.find_by_id(params[:club_id]).id
			    else	
			    	club_id = nil
			    end
				User.create :first_name => params[:first_name], :last_name => params[:last_name], :admin_permissions => admin_permissions, :club_id => club_id, :mail_address => params[:mail]
			end
			redirect_to user_index_path
		else
			redirect_to home_index_path
		end
	end

	def edit
		if@current_user.admin_permissions || User.find_by_id(params[:id]).id == @current_user.id
			if params[:id]
	      		@user = User.find_by_id params[:id]
	    	else
	      		redirect_to user_index_path
	    	end
    	else
			redirect_to home_index_path
		end
	end

	def update
		if@current_user.admin_permissions || User.find_by_id(params[:user_id]).id == @current_user.id
			if !params[:first_name].blank? && !params[:user_id].blank? && !params[:last_name].blank? && !params[:mail].blank?
	      		admin_permissions = false
	      		if !params[:admin_permissions].nil?
	        		admin_permissions = true
	      		end
	      		if !params[:club_id].blank?
			    	club_id = Club.find_by_id(params[:club_id]).id
			    else	
			    	club_id = nil
			    end
	      		User.find_by_id(params[:user_id]).update_attributes :first_name => params[:first_name], :last_name => params[:last_name], :admin_permissions => admin_permissions, :club_id => club_id, :mail_address => params[:mail]
	    	end
	    	redirect_to user_path params[:user_id]
	    else
	    	redirect_to home_index_path
	    end
	end

	def destroy
		if@current_user.admin_permissions || User.find_by_id(params[:id]).id == @current_user.id
			if params[:id]
		        if User.find_by_id params[:id]
		        	User.find_by_id(params[:id]).destroy
		        end
		    end
		    redirect_to user_index_path
		else
			redirect_to home_index_path
		end
	end

end