class Date
	def self.last_thursday
		today = Date.today
		week_beginning = today.beginning_of_week + 3
		return week_beginning - 7 unless week_beginning.past?
		week_beginning
	end
end
