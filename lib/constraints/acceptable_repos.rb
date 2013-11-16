class AcceptableRepos
	def self.matches?(req)
		req.fullpath =~ %r(/repo/Kelasi/(kelasi|kelasiTline)/.*)
	end
end
