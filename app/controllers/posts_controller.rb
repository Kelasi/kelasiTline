class PostsController < ApplicationController

  before_filter :auth, except: [:index]

  def index
    week = params[:week].to_i
  	@posts = Post.paginate(week).includes(:user, replies: :user)
    @user = current_user

    respond_to do |format|
      format.html
      format.json { render json: @posts.to_json(include: [:replies]) }
    end
  end

  def create
    @message = Post.new
    @message.user_id   = current_user.id
    @message.message   = params[:msg]
    @message.parent_id = params[:parent_id] if params[:parent_id].present?
    @message.dir       = params[:dir]
    @message.save
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: @message }
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.status = 0
    @post.save
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: @post }
    end
  end

  def update
    @post = Post.find(params[:id])
    @post.msg = params[:msg]
    @post.save
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { render json: @post }
    end
  end
  
  private

  	def auth
       unless logged_in?
      		redirect_to login_path, note: "You need to log in first"
       end
  	end
end
