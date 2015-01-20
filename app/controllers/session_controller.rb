class SessionController < ApplicationController

	before_action -> { check_session(false,false) }

	def create
		if !params[:mail_address].blank? && !params[:password].blank?
			user = User.authenticate(params[:mail_address],params[:password])
			if user
				cookies.signed[:user_id] = user.id
				redirect_to home_index_path
			else
				redirect_to home_index_path
			end
		else
			redirect_to home_index_path
		end
	end

	def destroy
		cookies.signed[:user_id] = nil
		redirect_to home_index_path
	end

	def register
		if !@current_user
			if params[:first_name] && params[:last_name] && params[:mail] && params[:repeated_mail] && params[:password] && params[:repeated_password]
				successful_registration = false
				if !params[:first_name].blank? && !params[:last_name].blank? && !params[:mail].blank? && !params[:repeated_mail].blank? && !params[:password].blank? && !params[:repeated_password].blank?
				    if !params[:club_name].blank?
				    	club_id = Club.find_by_name(params[:club_name]).id
				    else	
				    	club_id = nil
				    end
				    if params[:mail] == params[:repeated_mail]
				    	if params[:password] == params[:repeated_password]
							User.create :password => params[:password], :first_name => params[:first_name], :last_name => params[:last_name], :admin_permissions => false, :club_id => club_id, :mail_address => params[:mail]
							successful_registration = true
						end
					end
				end
				if successful_registration
					redirect_to home_index_path
				else
					redirect_to register_path
				end
			end
		else
			redirect_to home_index_path
		end
	end

	def change_password
		if @current_user
			if params[:user_id] && params[:old_password] && params[:new_password] && params[:repeated_new_password]
				if !params[:user_id].blank? && !params[:old_password].blank? && !params[:new_password].blank? && !params[:repeated_new_password].blank?
					user = User.authenticate(@current_user.mail_address,params[:old_password])
					if user
						if params[:new_password] == params[:repeated_new_password]
							user.update_attributes :password => params[:new_password]
							redirect_to logout_path
						else
							redirect_to change_password_path
						end
					else
						redirect_to change_password_path
					end
				else
					redirect_to change_password_path
				end
			end
		else
			redirect_to home_index_path
		end
	end

	def forgot_password
		if !@current_user
			if params[:mail_address]
				if !params[:mail_address].blank?
					user = User.find_by_mail_address(params[:mail_address])
					if user
						random_chars_array = [('a'..'z'), ('A'..'Z'),(0..9)].map { |i| i.to_a }.flatten
						random_password = (0...30).map {random_chars_array[rand(random_chars_array.length)] }.join
						user.update_attributes :password => random_password
						UserMailer.forgot_password(user).deliver
						redirect_to home_index_path
					else
						redirect_to forgot_password_path
					end
				else
					redirect_to forgot_password_path
				end
			end
		else
			redirect_to home_index_path
		end
	end

end