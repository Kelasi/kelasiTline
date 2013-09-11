
class Users
  constructor: (@q, @http) ->

  data: {}
  loaded: false

  load: () ->
    r = @q.defer()
    @http.get("/users.json").success (data_r) =>
      result = @data
      for p of result
        delete result[p]
      for user in data_r
        result[user.id.toString()] = user
      @loaded = true
      r.resolve result
    return r.promise

timeline_model.factory "users",
  ['$q', '$http', ($q, $http)->
    new Users $q, $http
  ]
