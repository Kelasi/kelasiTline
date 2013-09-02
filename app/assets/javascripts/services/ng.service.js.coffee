

ngapp_service = angular.module("ngapp.service", [])


class Command
  constructor: (@http, @q, @rootScope, @cookieStore, @posts, @users) ->

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
            data.replies ?= []
            @posts.data.unshift data

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
            for p in @posts.data
              if p.id == data.parent_id
                p.replies ?= []
                p.replies.unshift data

      when "logout"
        @http.get('/logout').success =>
          @rootScope.loggedInUser = null
          @cookieStore.put 'loggedInUser', null

      when "login"
        @q.when(@users.data).then (users) =>
          user = (users[u] for u of users when users[u].name == parameter)
          if user.length == 1
            user = user[0]
          else
            result.reject 'User not found'
            return result.promise
          @http.post('/login.json', user)
            .success (data) =>
              return unless data.id == user.id

              @rootScope.loggedInUser = user
              @cookieStore.put 'loggedInUser', user

      when 'delete'
        user = @rootScope.loggedInUser
        unless user?
          result.reject 'You should loggin first'
          return result.promise
        post = (p for p in @posts.data when p.id.toString() == parameter)
        unless post.length == 1
          for p in @posts.data
            for q in p.replies
              if q.id.toString() == parameter
                 post = [q]
          unless post.length == 1 
            result.reject 'There is no post with this id'
            return result.promise
        if post[0].user_id != user.id
          result.reject 'You do not have permission to delete this post'
          return result.promise
        @http.delete("/posts/#{parameter}.json")
          .success (data) ->
            id = "#post-#{data.id}"
            $(id).slideUp()
      else
        result.reject 'Command not found'
        return result.promise

ngapp_service.factory("command",
  ['$http', '$q', '$rootScope', '$cookieStore', 'posts', 'users',
  ($http, $q, $rootScope, $cookieStore, posts, users) ->
    new Command $http, $q, $rootScope, $cookieStore ,posts, users
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

ngapp_service.factory("notification",
  ['$rootScope', '$q', ($rootScope, $q) ->
    new Notification $rootScope, $q
  ]
)

