

angular.module("timeline.directive", [])
  .directive('timelineNotify', ->
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
        attrs.$observe 'timelineNotify', (value) ->
          if value? and value != ''
            $(element).find('#notification-message').text value
            delay = parseInt attrs['delay']
            $(element).delay(delay).slideDown()
          else
            $(element).stop(true, false).slideUp()
    }
  ).directive('timelineTimeago', ['timeago', (timeago)->
    {
      restrict: 'A'
      template: '<time></time>'
      replace: true
      scope: false
      link: (scope, element, attrs) ->
        timeagoIndex = timeago.timeagos.length
        timeago.timeagos.push [$(element), moment()]
        attrs.$observe 'timelineTimeago', (time) ->
          timeago.timeagos[timeagoIndex][1] = moment(time)
        element.on '$destroy', ->
          if timeagoIndex?
            timeago.timeagos[timeagoIndex] = null
    }
  ]).directive('timelinePost', ['$compile', ($compile) ->
    {
      restrict: 'A'
      template:
        '<div class="post">
          <div class="span2 center">
              <img class="img-circle inline-profile-photo shadow" ng-src="{{image}}" />
              <div class="vertical-line"></div>
          </div>
          <div class="span10">
            <div class="span12 round5 command-div shadow">
              <img class="my-arrow-box" src="/assets/timeline-images/arrow-box.png" />
              <div class="post-id">
                {{post_id}}
              </div>
              <div class="timeago" timeline-timeago="{{post_time}}"></div>
              <div class="post-message-container">
                {{post_message}}
              </div>
              <div id="rest"></div>
            </div>
          </div>
        </div>'
      replace: true
      scope:
        post: '=timelinePost'
      link: (scope, element, attrs) ->
        scope.image = scope.post.user().picture
        scope.post_id = scope.post.id
        scope.post_time = scope.post.created_at
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
              <div class="reply" id="post-#{scope.post.replies[index].id}">
                <hr>
                <div timeline-post="post.replies[#{index}]"></div>
              </div>
            """)
          $compile(replyElement.contents())(scope)
        , true)
    }
  ]).directive('sidebar',[->
    {
      restrict: 'E'
      template:
        '<div class="sidebar">
          <div class="scrollbar-x"></div>
          <div class="scrollbar-y"></div>
          <div ng-transclude></div>
        </div>'
      replace: true
      scope: false
      transclude: true
      link: (scope, element, attrs) ->
        $(element).perfectScrollbar()
    }
  ])

