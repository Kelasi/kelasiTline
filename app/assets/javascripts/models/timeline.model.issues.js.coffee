class kelasiTlineIssues
	constructor:  (@q, @http) ->

	data: []

	issues: ->
		r = @q.defer()
		@http.get("github.json?repo=kelasiTline").success (data_r) =>
			@data = data_r
			r.resolve @data
		r.promise

	concatenate: (issue) =>
	    @data['unshift'] issue

timeline_model.factory 'kelasiTlineIssues',
	['$q', '$http', ($q, $http)->
		new kelasiTlineIssues $q, $http
	]


class kelasiIssues
	constructor: (@q, @http) ->

	data: []

	issues: ->
		r = @q.defer()
		@http.get("github.json?repo=kelasi").success (data_r) =>
			@data = data_r
			r.resolve @data
		r.promise

	concatenate: (issue) =>
	    @data['unshift'] issue

timeline_model.factory 'kelasiIssues',
	['$q', '$http', ($q, $http)->
		new kelasiIssues $q, $http
	]
