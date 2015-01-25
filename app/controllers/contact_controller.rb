class ContactController < ApplicationController

	before_action -> { check_session(false,false) }

	def index

	end

	def create
		if !params[:name].blank? && !params[:mail].blank? && !params[:subject].blank? && !params[:message].blank?
			ContactMailer.send_contact_form(params[:name], params[:mail], params[:subject], params[:message]).deliver
			redirect_to contact_index_path
		else
			redirect_to contact_index_path
		end
	end

end