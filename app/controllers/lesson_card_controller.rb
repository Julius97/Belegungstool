class LessonCardController < ApplicationController

	before_action -> { check_session(true,false) }

	def index
		if @current_user.admin_permissions
			@actual_lesson_cards = LessonCard.where("remaining > 0").order(:initially,:created_at)
			@archived_lesson_cards = LessonCard.where(:remaining => 0).order(:updated_at)
		else
			@actual_lesson_cards = LessonCard.where("user_id = ? AND remaining > ?", @current_user.id, 0).order(:initially,:created_at)
		end
	end

	def new

	end

	def create
		allowed_to_create = false
		if !params[:user_id].blank? && !params[:initially].blank?
			if params[:initially].to_i > 0
				if !@current_user.admin_permissions
					if params[:user_id].to_i == @current_user.id
						if LessonCard.where("user_id = ? AND remaining > ?", params[:user_id], 0).count == 0
							allowed_to_create = true
						end
					end
				else
					if LessonCard.where("user_id = ? AND remaining > ?", params[:user_id], 0).count == 0
						allowed_to_create = true
					end
				end
				if allowed_to_create
					LessonCard.create :user_id => params[:user_id].to_i, :initially => params[:initially].to_i, :remaining => params[:initially].to_f
				end
			end 
		end
		redirect_to lesson_card_index_path
	end

	def show
		if @current_user.admin_permissions
			@lesson_card = LessonCard.find_by_id params[:id]
		else
			if LessonCard.find_by_id(params[:id]).user_id == @current_user.id
				if LessonCard.find_by_id(params[:id]).remaining > 0
					@lesson_card = LessonCard.find_by_id params[:id]
				else
					redirect_to lesson_card_index_path
				end
			else
				redirect_to lesson_card_index_path
			end
		end
	end

	def edit
		if @current_user.admin_permissions
			if LessonCard.find_by_id(params[:id]).remaining > 0
				@lesson_card = LessonCard.find_by_id params[:id]
			else
				redirect_to lesson_card_index_path
			end
		else
			if LessonCard.find_by_id(params[:id]).user_id == @current_user.id
				if LessonCard.find_by_id(params[:id]).remaining > 0
					@lesson_card = LessonCard.find_by_id params[:id]
				else
					redirect_to lesson_card_index_path
				end
			else
				redirect_to lesson_card_index_path
			end
		end
	end

	def update

	end

	def destroy
		allowed_to_destroy = false
		if params[:id]
			if @current_user.admin_permissions
				allowed_to_destroy = true
      		else
      			lesson_card = LessonCard.find_by_id params[:id]
      			if lesson_card.user_id == @current_user.id
      				if lesson_card.remaining > 0
 						allowed_to_destroy = true
      				end
      			end
      		end
    	end
    	if allowed_to_destroy
			if params[:id]
		        if LessonCard.find_by_id params[:id]
		        	LessonCard.find_by_id(params[:id]).destroy
		        end
		    end
		end
	    redirect_to lesson_card_index_path
	end

end