class Github
	class << self

		def client
			@@client ||= Octokit::Client.new access_token: ENV['GITHUB_TOKEN']
		end

		alias :login :client

		def login?
			@@client ||= nil
			@@client.try(:user).try(:login?)
		end

		def issues(repo)
			repo ||= 'kelasiTline'
			client = self.client
			if repo == 'kelasiTline'
				client.issues 'kelasi/kelasiTline', per_page: 30
			elsif repo == 'kelasi'
				client.issues 'kelasi/kelasi', per_page: 30
			end
		end
	end
end
