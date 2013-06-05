class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  	def logged_in?
  		session['user'].is_a?(User)
  	end
end
