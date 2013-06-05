class PagesController < ApplicationController

  def timeline
  end

  def login
  end

  def do_login
  	session['user'] = User.find_by_name params['name']
  	redirect_to root_path
  end

  def logout
    session['user'] = nil
    redirect_to root_path
  end
end
