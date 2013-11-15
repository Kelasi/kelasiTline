class MilestonesController < ApplicationController

	around_filter :login, except: :index
	respond_to :json

	def index
		user = current_user
		user = User.first unless logged_in?
		@milestones = user.github.list_milestones repo
		respond_with @milestones
	end

	def create
		p params[:options]
		title = params[:title]
		options = {}
		options = params[:options].select {|k|
			['state', 'description', 'due_on'].include? k
		} if params[:options].present?
		@milestone = current_user.github.create_milestone(repo, title, options)
		render json: @milestone
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
