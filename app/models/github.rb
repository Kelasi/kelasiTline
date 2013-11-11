class Github
	class << self

		def client(user='Saeed')
			@@client ||= Octokit::Client.new access_token: token(user)
		end

		def token(user)
			ENV["#{user.upcase}_GITHUB_TOKEN"]
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
			elsif repo == 'saeedSarpas/kelasiTlineTDDhelper'
				client.issues 'saeedSarpas/kelasiTlineTDDhelper', per_page: 2
			end
		end

		def create_issue(repo, title, body, user)
			client = self.client(user)
			client.create_issue(repo, title, body)
		end
	end
end
