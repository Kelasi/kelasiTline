
class Users
  constructor: (@q, @http) ->

  data: {}

  load: () ->
    r = @q.defer()
    @http.get("/users.json").success (data_r) =>
      result = @data
      for p of result
        delete result[p]
      for user in data_r
        result[user.id.toString()] = user
      r.resolve result
    return r.promise

ngapp_model.factory "users",
  ['$q', '$http', ($q, $http)->
    new Users $q, $http
  ]
