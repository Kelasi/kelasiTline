class GithubsController < ApplicationController

	respond_to :json

	def index
		repo = params[:repo]
		@issues = Github.issues(repo)
		respond_with @issues
	end
end
