class User < ActiveRecord::Base
  attr_accessible :name

	def github
		unless @github.present?
			token = ENV["#{self.name.upcase}_GITHUB_TOKEN"]
			@github = Octokit::Client.new access_token: token
		end
		@github
	end

end
