class StaticController < ApplicationController
	
	before_action -> { check_session(false,false) }
	
end