class ApplicationController < ActionController::Base
  layout 'application'
  protect_from_forgery

  protected
  	def logged_in?
      self.current_user[:id].present?
  	end

  def current_user
    session['user'] ||= {picture: 'assets/user.png', name: 'Anonymous'}
  end

  def current_user=(user)
    session['user'] = user
  end
end
