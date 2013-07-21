
angular.module("ktmain.service", [])
  .factory("notification",
    ['$timeout', ($timeout) ->
      return {
        loading: (show = true) ->
          $timeout.cancel @timeout
          if show
            @timeout = $timeout (-> $('.alert-box').slideDown()), 0
          else
            $('.alert-box').slideUp()
      }
    ]
  )

angular.module("ktmain.directive", [])
angular.module("ktmain.filter", [])
  .filter("reverse", ->
    (arr) ->
      arr.slice().reverse()
  )
angular.module("ktmain", ["ktmain.service", "ktmain.directive", "ktmain.filter"])
  .controller "resourcesCtrl",
    ['$scope', '$http', '$timeout', 'notification', ($scope, $http, $timeout, notification) ->
      notification.loading on

      token = $("meta[name='csrf-token']").attr("content")
      $http.defaults.headers.common["X-CSRF-Token"] = token

      $scope.replyMsg = {}

      $scope.loggedInUser =
        picture: 'assets/user.png'
        notifications: 0

      $http.get("/users.json").success (data) ->
        $scope.users = {}
        for user in data
          $scope.users[user.id.toString()] = user
          $scope.users[user.id.toString()].notifications = 0

      $http.get("/posts.json").success (data) ->
        for p in data
          p.replies ?= []
        $scope.posts = data
        notification.loading off

      $scope.$watch 'posts', ->
        $timeout -> $('#all-posts').trigger 'initialize'

      $scope.userLogin = (userId) ->
        notification.loading on
        $http.post('/login.json', {name: $scope.users[userId].name})
          .success (data) ->
            return unless data.id == userId

            $scope.loggedInUser = data
            elm = $('#user-'+userId)
            elm.parents('section.section').siblings().find('a').removeClass('selected')
            elm.addClass 'selected'
            notification.loading off

      $scope.postSubmit = ->
        notification.loading on
        $http.post('/posts.json', {msg: $scope.postMessage})
          .success (data) ->
            unless data.user_id != $scope.loggedInUser.id
              data.replies ?= []
              $scope.posts.unshift data
              $scope.postMessage = ''
              $('textarea').height 0
              notification.loading off

      $scope.replyClick = (id) ->
        notification.loading on
        rep = $('#reply-'+id)
        msg = rep.val()
        rep.val ''
        $http.post('/posts.json', {msg: msg, parent_id: id})
          .success (data) ->
            for p in $scope.posts
              if p.id == data.parent_id
                p.replies.unshift data
            notification.loading off

      $scope.deletePost = (id) ->
        notification.loading on
        $http.delete("/posts/#{id}.json")
          .success (data) ->
            id = "#post-#{data.id}"
            $(id).slideUp()
            notification.loading off

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

$('#all-posts').on 'initialize', ->
  $('#all-posts time.timeago').timeago()
  $('textarea').autosize {append: "\n"}
  $('textarea').css 'resize', 'vertical'

