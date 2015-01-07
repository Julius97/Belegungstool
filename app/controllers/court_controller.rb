class CourtController < ApplicationController
  
  before_action -> { check_session(true,true) }

  def index
    @courts = Court.all
  end

  def show 
    if params[:id]
      @court = Court.find_by_id params[:id]
    else
      redirect_to court_index_path
    end
  end

  def new

  end

  def create
    if !params[:name].blank?
      name = params[:name]
      opened = false
      if !params[:opened].nil?
        opened = true
      end
      Court.create :name => name, :opened => opened
    end
    redirect_to court_index_path
  end

  def edit
    if params[:id]
      @court = Court.find_by_id params[:id]
    else
      redirect_to court_index_path
    end
  end

  def update
    if !params[:name].blank? && !params[:court_id].blank?
      name = params[:name]
      opened = false
      if !params[:opened].nil?
        opened = true
      end
      Court.find_by_id(params[:court_id]).update_attributes :name => name, :opened => opened
    end
    redirect_to court_path params[:court_id]
  end

  def destroy
    if params[:id]
      if Court.find_by_id params[:id]
        Court.find_by_id(params[:id]).destroy
      end
    end
    redirect_to court_index_path
  end

end