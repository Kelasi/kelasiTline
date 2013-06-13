
Array.prototype.reversed = ->
  @slice().reverse()
  
@loading = (show= true) ->
  clearTimeout @timeout
  if show
    @timeout = setTimeout("$('.alert-box').slideDown()", 50)
  else
    $('.alert-box').slideUp()

@resourcesCtrl = ['$scope', '$http', '$timeout', ($scope, $http, $timeout) ->
  loading on

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
    loading off

  $scope.$watch 'posts', ->
    $timeout -> $('#all-posts').trigger 'initialize'

  $scope.userLogin = (userId) ->
    loading on
    $http.post('/login.json', {name: $scope.users[userId].name})
      .success (data) ->
        return unless data.id == userId

        $scope.loggedInUser = data
        elm = $('#user-'+userId)
        elm.parents('section.section').siblings().find('a').removeClass('selected')
        elm.addClass 'selected'
        loading off

  $scope.postSubmit = ->
    loading on
    $http.post('/posts.json', {msg: $scope.postMessage})
      .success (data) ->
        unless data.user_id != $scope.loggedInUser.id
          data.replies ?= []
          $scope.posts.unshift data
          $scope.postMessage = ''
          $('textarea').height 0
          loading off

  $scope.replyClick = (id) ->
    loading on
    rep = $('#reply-'+id)
    msg = rep.val()
    rep.val ''
    $http.post('/posts.json', {msg: msg, parent_id: id})
      .success (data) ->
        for p in $scope.posts
          if p.id == data.parent_id
            p.replies.unshift data
        loading off

  $scope.deletePost = (id) ->
    loading on
    $http.delete("/posts/#{id}.json")
      .success (data) ->
        id = "#post-#{data.id}"
        console.log id
        $(id).slideUp()
        loading off

  $scope.properTime = (time) ->
    if time?
      time = time.slice time.indexOf('T')+1, time.indexOf('+')
    else ""
]

$('#all-posts').on 'initialize', ->
  $('#all-posts time.timeago').timeago()
  $('textarea').autosize {append: "\n"}
  $('textarea').css 'resize', 'vertical'

