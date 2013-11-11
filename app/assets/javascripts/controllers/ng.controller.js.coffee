
ngapp = angular.module 'ngapp'

ngapp.controller "resourcesCtrl",
    ['$scope', '$http', '$q', '$timeout', 'notification', 'users', 'posts',
    ($scope, $http, $q, $timeout, notification, users, posts) ->
      loading = (p) -> notification.loading p

      loading($scope.users = users.load())
      loading($scope.posts = posts.load())

      $scope.next_week_posts = ->
        $scope.next_week_loading = 'loading'
        posts.paginate_load().then -> $scope.next_week_loading = ''
    ]

ngapp.controller "commandCntl",
  [ '$scope', '$rootScope', 'notification', 'command'
  ($scope, $rootScope, notification, command) ->
    loading = (p) -> notification.loading p

    $scope.placeholder = "Try typing 'login <Your Name>'"
    $rootScope.$watch 'loggedInUser', (nval) ->
      $scope.placeholder = if nval?
        "Now You can type 'logout'"
      else
        "Try typing 'login <Your Name>'"

    loggedInUser = store.get 'loggedInUser'
    if loggedInUser?
      command.run('login', loggedInUser.name)
 
    history = []
    history_last = 0

    $scope.keyUp = ($event) ->
      if $event.keyCode == 38
        if history_last > 0
          history_last -= 1
          $scope.command = history[history_last]

      if $event.keyCode == 40
        if history.length > history_last >= 0
          history_last += 1
          $scope.command = history[history_last]
 
    $scope.runCommand = ->
      cmd_i = $scope.command.indexOf(' ')
      parameter = if cmd_i > 0 then $scope.command.substring(cmd_i).trim() else ''
      corr_command = if cmd_i > 0 then $scope.command.substring(0, cmd_i) else $scope.command
      loading(command.run(corr_command,parameter)).then ->
        history.push($scope.command)
        history_last = history.length
        $scope.command = ''
  ]
