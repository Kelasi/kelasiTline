
ngapp.controller "resourcesCtrl",
    ['$scope', '$http', '$q', '$timeout', 'notification', 'utilities', 'users', 'posts',
    ($scope, $http, $q, $timeout, notification, utilities, users, posts) ->
      loading = (p) -> notification.loading p

      init = ->
        utilities.initialization()
        $timeout init, 1500

      init()

      $scope.replyMsg = {}

      loading($scope.users = users.load())
      loading($scope.posts = posts.load())

      $scope.postSubmit = ->
        msg = $scope.postMessage.trim()
        return if msg == ''

        loading $http.post('/posts.json', {msg: $scope.postMessage})
          .success (data) ->
            unless data.user_id != $scope.loggedInUser.id
              data.replies ?= []
              $q.when($scope.posts).then (p) -> p.unshift data
              $scope.postMessage = ''
              $('textarea').height 0
              $timeout ->
                $('#post-panel a.button').removeClass('disabled')

        $('#post-panel a.button').addClass('disabled')

      $scope.replyClick = (id) ->
        rep = $('#reply-'+id)
        msg = rep.val()
        rep.val ''
        loading $http.post('/posts.json', {msg: msg, parent_id: id})
          .success (data) ->
            $q.when($scope.posts).then (posts) ->
              for p in posts
                if p.id == data.parent_id
                  p.replies.unshift data

      $scope.deletePost = (id) ->
        loading $http.delete("/posts/#{id}.json")
          .success (data) ->
            id = "#post-#{data.id}"
            $(id).slideUp()

      $scope.showDelete = (id, show) ->
        item = $("#post-#{id} > .row > .columns > .delete-button")
        if show
          item.show()
        else
          item.hide()

      $scope.showReply = (id) ->
        $("#post-#{id} .reply-placeholder").hide()
        $("#post-#{id} .reply-box").show()

      $scope.properTime = (time) ->
        if time?
          time = time.slice time.indexOf('T')+1, time.indexOf('+')
        else ""
    ]

ngapp.controller "commandCntl",
  [ '$scope', '$rootScope', '$http', '$q', '$cookieStore', 'users', 'posts', 'notification'
  ($scope, $rootScope, $http, $q, $cookieStore, users, posts, notification) ->
    loading = (p) -> notification.loading p
    $scope.placeholder = "Try typing 'login <Your Name>'"
    loggedInUser = $cookieStore.get 'loggedInUser'
    if loggedInUser?
      $http.post('/login.json', loggedInUser)
        .success (data) ->
          return unless data.id == loggedInUser.id

          $scope.placeholder = "Now You can type 'logout'"
          $rootScope.loggedInUser = loggedInUser

    $scope.runCommand = ->
      cmd = $scope.command.split ' '
      if ( cmd[0] == 'reply'&& cmd[1] == 'to' )
        id = cmd[2]
        cmd2l = cmd[2].length 
        commandl = $scope.command.length
        rep = $('#reply-'+id)
        repContent = $scope.command.substring(10+cmd2l,commandl)
        return if repContent == ''
        rep.val(repContent)
        msg = rep.val()
        rep.val ''
        loading $http.post('/posts.json', {msg: msg, parent_id: id})
          .success (data) ->
            $q.when($scope.posts).then (posts) ->
              for p in posts
                if p.id == data.parent_id
                  p.replies.unshift data    
            $scope.command = ''          

      if cmd[0] == 'post'
        lc = $scope.command.length
        $scope.newCommand = $scope.command.substring(5,lc) 
        msg = $scope.newCommand.trim()
        return if msg == ''

        loading $http.post('/posts.json', {msg: $scope.newCommand})
          .success (data) ->
            unless data.user_id != $scope.loggedInUser.id
              data.replies ?= []
              $q.when($scope.posts).then (p) -> p.unshift data
              $scope.command = ''
      
      if cmd[0] == 'reload'
        posts.load().then ->
          $scope.command = ''

      if cmd[0] == 'login'
        loading $q.when(users.data).then (users) ->
          user = (users[u] for u of users when users[u].name == cmd[1])
          if user.length == 1
            user = user[0]
          else
            console.log 'Error', user, users, cmd
            return
          $http.post('/login.json', user)
            .success (data) ->
              return unless data.id == user.id

              $scope.command = ''
              $scope.placeholder = "Now You can type 'logout'"
              $rootScope.loggedInUser = user
              $cookieStore.put 'loggedInUser', user
      if cmd[0] == 'logout'
        loading $http.get('/logout').success ->
          $rootScope.loggedInUser = null
          $cookieStore.put 'loggedInUser', null
          $scope.command = ''
          $scope.placeholder = "Try typing 'login <Your Name>'"
  ]
