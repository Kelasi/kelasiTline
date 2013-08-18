

class Posts
  constructor: (@q, @http) ->

  data: []

  load: () ->
    r = @q.defer()
    @http.get("/posts.json").success (data_r) =>
      result = @data
      result.length = 0
      for p in data_r
        p.replies ?= []
        result.push p
      r.resolve result
    r.promise

  delete: (id) ->
    $http.delete("/posts/#{id}.json")
      .success (data) ->
        i = 0
        while @data[i].id != data.id
          i++
        while i < @data.length-1
          @data[i] = @data[i+1]
          i++
        @data.length -= 1


ngapp_model.factory 'posts',
  ['$q', '$http', ($q, $http)->
    new Posts $q, $http
  ]
