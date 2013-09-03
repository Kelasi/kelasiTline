

angular.module("ngapp.directive", [])
  .directive('ngappNotify', ->
    {
      restrict: 'A'
      template:
        '<div class="alert-box alert" data-alert style="display:none">
          <a href="javascript:location.reload()">reload</a>
          <i class="icon-info-sign"></i>
          <span id="notification-message"></span>
        </div>'
      replace: true
      scope: false
      link: (scope, element, attrs) ->
        attrs.$observe 'ngappNotify', (value) ->
          if value? and value != ''
            $(element).find('#notification-message').text value
            delay = parseInt attrs['delay']
            $(element).delay(delay).slideDown()
          else
            $(element).stop(true, false).slideUp()
    }
  ).directive('ngappTimeago', ['$timeout', ($timeout)->
    {
      restrict: 'A'
      template: '<time></time>'
      replace: true
      scope: false
      link: (scope, element, attrs) ->
        timeoutId = null
        time = null
        attrs.$observe 'ngappTimeago', (v) -> time = moment(v)
        tick = ->
          $(element).text time?.fromNow()
          timeoutId = $timeout((->tick()), 5000)
        tick()
        element.on '$destroy', ->
          if timeoutId?
            $timeout.cancel timeoutId
    }
  ]).directive('ngappPost', ['$compile', ($compile) ->
    {
      restrict: 'A'
      template:
        '<div class="row">
          <div class="large-1 columns">
            <img class="radius" ng-src="{{image}}" />
          </div>
          <div class="large-11 columns">
            <span class="post-id">
              {{post_id}}
            </span>
            <div class="timeago" ngapp-timeago="{{post_time}}"></div>
            <pre>{{post_message}}</pre>
            <div id="rest"></div>
          </div>
        </div>'
      replace: true
      scope:
        post: '=ngappPost'
      link: (scope, element, attrs) ->
        scope.image = scope.post.user().picture
        scope.post_id = scope.post.id
        scope.post_time = scope.post.updated_at
        scope.$watch 'post.msg', (value) ->
          scope.post_message = scope.post.msg
        replyElement = $(element).find('#rest')
        scope.$watch('post.replies', (v) ->
          replyElement.empty()
          return unless v?
          index = scope.post.replies.length
          while index > 0
            index--
            replyElement.append $("""
              <hr>
              <div ngapp-post="post.replies[#{index}]"></div>
            """)
          $compile(replyElement.contents())(scope)
        , true)
    }
  ])

