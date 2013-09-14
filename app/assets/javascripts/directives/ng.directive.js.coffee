

angular.module("ngapp.directive", [])
  .directive('ngappNotify', ->
    {
      restrict: 'A'
      scope: false
      link: (scope, element, attrs) ->
        scope.flipload = flipload = new Flipload element[0],
          line: 'horizontal', className: 'ngapp-flipload'
        attrs.$observe 'ngappNotify', (value) ->
          if value? and value != ''
            delay = parseInt attrs['delay']
            flipload.load()
          else
            flipload.done()
    }
  ).directive('ngappStick', ['$timeout', ($timeout) ->
    {
      restrict: 'A'
      scope: false
      link: (scope, element, attrs) ->
        do_bind = ->
          unless $(element).siblings().toArray().every((e) -> e.offsetHeight > 0)
            $timeout( ->
              do_bind()
            , 300)
            return
          $(element).css('z-index', 1000).stick_in_parent()
        do_bind()
    }
  ]).directive('ngappTimeago', ['timeago', (timeago)->
    {
      restrict: 'A'
      template: '<time></time>'
      replace: true
      scope: false
      link: (scope, element, attrs) ->
        timeagoIndex = timeago.timeagos.length
        timeago.timeagos.push [$(element), moment()]
        attrs.$observe 'ngappTimeago', (time) ->
          timeago.timeagos[timeagoIndex][1] = moment(time)
        element.on '$destroy', ->
          if timeagoIndex?
            timeago.timeagos[timeagoIndex] = null
    }
  ]).directive('ngappPost', ['$compile', ($compile) ->
    {
      restrict: 'A'
      template:
        '<div class="row"
              ng-mouseenter="mouseEnter()"
              ng-mouseleave="mouseLeave()">
          <div class="large-1 columns">
            <img class="radius" ng-src="{{image}}?x" />
          </div>
          <div class="large-11 columns {{post_class}}">
            <div class="timeago" ngapp-timeago="{{post_time}}"></div>
            <span class="post-id" style="display:none">
              - <a>#{{post_id}}</a>
            </span>
            <div id="message"></div>
            <div id="rest"></div>
          </div>
        </div>'
      replace: true
      scope:
        post: '=ngappPost'
        post_class: '@postClass'
      link: (scope, element, attrs) ->
        scope.image = scope.post.user().picture
        scope.post_id = scope.post.id
        scope.post_time = scope.post.updated_at
        scope.$watch 'post.msg', (value) ->
          $(element).find('#message').first()
            .append $.parseHTML(scope.post.msg)
        replyElement = $(element).find('#rest')
        scope.$watch('post.replies', (v) ->
          replyElement.empty()
          return unless v?
          index = scope.post.replies.length
          while index > 0
            index--
            replyElement.append $("""
              <div id="post-#{scope.post.replies[index].id}">
                <hr>
                <div ngapp-post="post.replies[#{index}]"></div>
              </div>
            """)
          $compile(replyElement.contents())(scope)
        , true)
        scope.mouseEnter = -> $(element).find('.post-id').first().fadeIn()
        scope.mouseLeave = -> $(element).find('.post-id').first().fadeOut()
    }
  ])

