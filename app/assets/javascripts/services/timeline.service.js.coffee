

timeline_service = angular.module("timeline.service", [])


class Command
  constructor: (@timeout, @http, @q, @rootScope, @posts, @users) ->

  run: (commandd, parameter) ->

    result = @q.defer()
    switch commandd
      when "post"

        msg = parameter
        if msg == ''
          result.reject "Post parameteres should not be empty"
          return result.promise

        @http.post('/posts.json', {msg: parameter})
          .success (data) =>
            @posts.append data, true

      when "edit"
        id_place = parameter.indexOf(' ')
        id = parseInt(parameter.substring(0, id_place))
        if isNaN(id)
          result.reject 'You should pass an Id number here.'
          return result.promise
        edit_section = parameter.substring(id_place).trim()
        sepMark_place = edit_section.indexOf('>>')
        orig_text = eval(edit_section.substring(0,sepMark_place-1))
        corr_text = edit_section.substring(sepMark_place+2)
        user = @rootScope.loggedInUser
        unless user?
          result.reject 'You should be logged in first'
          return result.promise
        post = ([p, i] for p, i in @posts.data when p.id == id)
        unless post.length == 1
          for p,i in @posts.data
            for q,j in p.replies
              if q.id == id
                 post = [[q,i,j]]
          unless post.length == 1
            result.reject 'There is no post with this id'
            return result.promise
        post_index = post[0][1]
        reply_index = post[0][2]
        post = post[0][0]
        if post.user_id != user.id
          result.reject 'You do not have permission to delete this post'
          return result.promise
        edited_text = post.msg.replace(orig_text,corr_text)
        @http.put("/posts/#{id}.json", {msg: edited_text}) 
          .success (value) =>
            if reply_index?
              @posts.data[post_index].replies[reply_index].msg = value.msg
            else
              @posts.data[post_index].msg = value.msg
      when "reload"
        @posts.load()

      when "reply"
        id = parameter.substring(0, parameter.indexOf(' '))
        repContent = parameter.substring(parameter.indexOf(' ')).trim()
        if repContent == ''
          result.reject 'Reply can not be empty'
          return result.promise
        @http.post('/posts.json', { msg: repContent, parent_id: id})
          .success (data) =>
            for p, i in @posts.data
              if p.id == data.parent_id
                @posts.append_reply i, data

      when "logout"
        @http.get('/logout').success =>
          @rootScope.loggedInUser = null
          store.remove 'loggedInUser'

      when "login"
        do_login = =>
          unless @users.loaded
            @timeout do_login, 30
            return
          user = (@users.data[u] for u of @users.data when @users.data[u].name == parameter)
          if user.length == 1
            user = user[0]
          else
            result.reject 'User not found'
            return result.promise
          @http.post('/login.json', user)
            .success (data) =>
              return unless data.id == user.id

              @rootScope.loggedInUser = user
              store.set 'loggedInUser', user
        do_login()

      when 'delete'
        user = @rootScope.loggedInUser
        unless user?
          result.reject 'You should loggin first'
          return result.promise
        post = ([p, i] for p, i in @posts.data when p.id.toString() == parameter)
        unless post.length == 1
          for p, i in @posts.data
            for q, j in p.replies
              if q.id.toString() == parameter
                 post = [[q, i, j]]
          unless post.length == 1 
            result.reject 'There is no post with this id'
            return result.promise
        post_index = post[0][1]
        reply_index = post[0][2]
        post = post[0][0]
        if post.user_id != user.id
          result.reject 'You do not have permission to delete this post'
          return result.promise
        @http.delete("/posts/#{parameter}.json")
          .success (data) =>
            id = "#post-#{data.id}"
            if reply_index?
              @posts.data[post_index].replies.splice(reply_index, 1)
            else
              @posts.data.splice post_index, 1
      else
        result.reject 'Command not found'
        return result.promise

timeline_service.factory("command",
  ['$timeout', '$http', '$q', '$rootScope', 'posts', 'users',
  ($timeout, $http, $q, $rootScope, posts, users) ->
    new Command $timeout, $http, $q, $rootScope, posts, users
  ]
)

class Notification
  constructor: (@rootScope, @q) ->

  jobs: []
  promises: []

  clean: ->
    @rootScope.notification = null

  check: ->
    if (0 for j in @jobs when j.done).length
      @jobs = []
      @promises = []
      @clean()

  loading: (promise) ->
    @rootScope.notification = "Still Working..."

    @jobs.push job = done: no
    finish_func = =>
      job.done = yes
    @promises.push promise.then finish_func, finish_func
    @q.all(@promises).then => @check()
    promise

timeline_service.factory("notification",
  ['$rootScope', '$q', ($rootScope, $q) ->
    new Notification $rootScope, $q
  ]
)

class TimeAgo
  constructor: (@timeout) ->
    @timeout((=>@tick()), 200)

  timeagos: []

  tick: ->
    t[0].text t[1].fromNow() for t in @timeagos when t?
    @timeout((=>@tick()), 5000)

timeline_service.factory("timeago",
  ['$timeout', ($timeout) ->
    new TimeAgo $timeout
  ]
)

