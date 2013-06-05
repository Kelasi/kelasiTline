class PostsController < ApplicationController

  before_filter :auth

  def index
  	@posts = Post.recent_posts.includes(:user, replies: :user)
    @user = session['user']
  end

  def create
    @message = Post.new
    @message.user_id   = session['user'].id
    @message.msg       = params[:msg]
    @message.parent_id = params[:parent_id] if params[:parent_id].present?
    @message.dir       = params[:dir]
    @message.save
    redirect_to root_path
  end

  private

  	def auth
       unless logged_in?
      		redirect_to login_path, note: "You need to log in first"
       end
  	end
end
