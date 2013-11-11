class GithubsController < ApplicationController

	before_filter :auth, except: [:index]
	respond_to :json

	def index
		repo = params[:repo]
		@issues = Github.issues(repo)
		respond_with @issues
	end

	def create
		repo  = params[:repo]
		title = params[:title]
		body  = params[:body]
		@response = Github.create_issue(repo, title, body, current_user.name)
		render json: @response
	end

	private
		def auth
			unless logged_in?
			redirect_to login_path, note: "You need to log in first"
		end
	end
end
