class PriceController < ApplicationController

	before_action -> { check_session(true,true) }

	def index
		@prices = PriceList.all
	end

	def new

	end

	def create
		if !params[:price].blank? && !params[:lesson].blank? && !params[:from_hour].blank? && !params[:from_min].blank? && !params[:to_hour].blank? && !params[:to_min].blank?
			from_time = DateTime.new(2015,01,01,params[:from_hour].to_i,params[:from_min].to_i,00,"+1")
			to_time = DateTime.new(2015,01,01,params[:to_hour].to_i,params[:to_min].to_i,00,"+1")
			if from_time < to_time
				if params[:price].to_f > 0
					PriceList.create :price => params[:price].to_f, :lesson => params[:lesson], :from_time => from_time, :to_time => to_time
				end
			end
		end
		redirect_to price_index_path
	end

	def show
		if params[:id]
      		@price = PriceList.find_by_id params[:id]
	    else
	      	redirect_to price_index_path
	    end
	end

	def edit
		if params[:id]
			if PriceList.find_by_id params[:id]
				@price = PriceList.find_by_id params[:id]
			else
				redirect_to price_index_path
			end
		else
			redirect_to price_index_path
		end
	end

	def update
		if !params[:price_id].blank? && !params[:price].blank? && !params[:lesson].blank? && !params[:from_hour].blank? && !params[:from_min].blank? && !params[:to_hour].blank? && !params[:to_min].blank?
			from_time = DateTime.new(2015,01,01,params[:from_hour].to_i,params[:from_min].to_i,00,"+1")
			to_time = DateTime.new(2015,01,01,params[:to_hour].to_i,params[:to_min].to_i,00,"+1")
			if PriceList.find_by_id(params[:price_id])
				if from_time < to_time
					if params[:price].to_f > 0
						PriceList.find_by_id(params[:price_id]).update_attributes :price => params[:price].to_f, :lesson => params[:lesson], :from_time => from_time, :to_time => to_time
					end
				end
			end
		end
		redirect_to price_path params[:price_id]
	end

	def destroy
		if params[:id]
      		if PriceList.find_by_id params[:id]
        		PriceList.find_by_id(params[:id]).destroy
      		end
   	 	end
    	redirect_to price_index_path
	end

end