class IssuesController < ApplicationController

	around_filter :login, except: :index
	respond_to :json

	def index
		user = current_user
		user = User.first unless logged_in?
		@issues = user.github.issues repo
		respond_with @issues
	end

	def create
		title   = params[:title]
		body    = params[:body]
		options = {}
		options = params[:options].select {|k|
			['assignee', 'milestone', 'labels'].include? k
		} if params[:options].present?
		@issue = current_user.github.create_issue(repo, title, body, options)
		render json: @issue
	end

	def update
		id = params[:id]
		title = params[:title]
		body = params[:body]
		options = {}
		options = params[:options].select {|k|
			['assignee', 'milestone', 'labels', 'state'].include? k
		} if params[:options].present?
		@issue = current_user.github.update_issue(repo, id, title, body, options)
		render json: @issue
	end

	def destroy
		id = params[:id]
		options = {}
		options = params[:options].select {|k|
			['assignee', 'milestone', 'labels', 'state'].include? k
		} if params[:options].present?
		@issue = current_user.github.close_issue(repo, id, options)
		render json: @issue
	end

	private
		def login
			if current_user.blank? or current_user.name == 'Anonymous'
				render json: {status: 'need login'}, status: :unprocessable_entity
			else
				yield
			end
		end

		def repo
			org = params[:org]
			rpo = params[:repo]
			"#{org}/#{rpo}"
		end
end
