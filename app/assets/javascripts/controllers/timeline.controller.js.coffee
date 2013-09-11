
timeline = angular.module 'timeline'

timeline.controller "resourcesCtrl",
    ['$scope', 'notification', 'users', 'posts',
    ($scope, notification, users, posts) ->
      loading = (p) -> notification.loading p

      loading($scope.users = users.load())
      loading($scope.posts = posts.load())
    ]

timeline.controller "commandCntl",
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

    $scope.runCommand = ->
      cmd_i = $scope.command.indexOf(' ')
      parameter = if cmd_i > 0 then $scope.command.substring(cmd_i).trim() else ''
      corr_command = if cmd_i > 0 then $scope.command.substring(0, cmd_i) else $scope.command
      loading command.run(corr_command,parameter)
      $scope.command = ''
  ]
