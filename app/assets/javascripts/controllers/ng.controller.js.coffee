
ngapp = angular.module 'ngapp'

ngapp.controller "resourcesCtrl",
    ['$scope', '$http', '$q', '$timeout', 'notification', 'users', 'posts',
    ($scope, $http, $q, $timeout, notification, users, posts) ->
      loading = (p) -> notification.loading p

      $scope.replyMsg = {}

      loading($scope.users = users.load())
      loading($scope.posts = posts.load())

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

      $scope.properTime = (time) ->
        if time?
          time = time.slice time.indexOf('T')+1, time.indexOf('+')
        else ""
    ]

ngapp.controller "commandCntl",
  [ '$scope', '$rootScope', '$cookieStore', 'notification', 'command'
  ($scope, $rootScope, $cookieStore, notification, command) ->
    loading = (p) -> notification.loading p

    $scope.placeholder = "Try typing 'login <Your Name>'"
    $rootScope.$watch 'loggedInUser', (nval) ->
      $scope.placeholder = if nval?
        "Now You can type 'logout'"
      else
        "Try typing 'login <Your Name>'"

    loggedInUser = $cookieStore.get 'loggedInUser'
    if loggedInUser?
      command.run('login', loggedInUser.name)

    $scope.runCommand = ->
      cmd_i = $scope.command.indexOf(' ')
      parameter = if cmd_i > 0 then $scope.command.substring(cmd_i).trim() else ''
      corr_command = if cmd_i > 0 then $scope.command.substring(0, cmd_i) else $scope.command
      loading command.run(corr_command,parameter)
      $scope.command = ''
  ]
