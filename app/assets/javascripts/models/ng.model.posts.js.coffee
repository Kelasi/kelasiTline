

class Posts
  constructor: (@q, @http, @users) ->

  data: []

  load: () ->
    r = @q.defer()
    @http.get("/posts.json").success (data_r) =>
      @data.length = 0
      @append p for p in data_r
      r.resolve @data
    r.promise

  append: (post, prepend=false) ->
    make_post = (p) =>
      p.user = => @users.data[p.user_id.toString()]
      if p.replies? and p.replies.length > 0
        p.replies =
          make_post(rep) for rep in p.replies
      else p.replies = []
      p
    @data[`prepend ? 'unshift': 'push'`] make_post post

  append_reply: (post_index, reply) ->
    reply.user = => @users.data[reply.user_id.toString()]
    reply.replies = []
    @data[post_index].replies.unshift reply

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
  ['$q', '$http', 'users', ($q, $http, users)->
    new Posts $q, $http, users
  ]
