

angular.module("timeline.directive", [])
  .directive('timelineNotify', ->
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
  ).directive('timelineappIssues', [
    '$q', 'kelasiIssues', 'kelasiTlineIssues'
    ($q, kelasiIssues, kelasiTlineIssues) ->
      {
        restrict: 'E'
        template:
          '<div class="col-md-12" timelineapp-Stick>
            <div class="issues" ng-cloak ng-show="issues_loaded">
              <header>
                <h4>kelasi Issues</h4>
                <hr />
              </header>
              <div ng-repeat="issues in kelasi_issues" ng-cloak>
                <div class="title">
                  {{issues.title}}
                </div>
                <div class="body">
                  {{issues.body}}
                </div>
                <hr />
              </div>
              <header>
                <h4>kelasiTline Issues</h4>
                <hr />
              </header>
              <div ng-repeat="issues in kelasiTline_issues">
                <div class="title">
                  {{issues.title}}
                </div>
                <div class="body">
                  {{issues.body}}
                </div>
                <hr />
              </div>
            </div>
          </div>'
        replace: true
        link: (scope, element, attrs) ->
          scope.issues_loaded = false
          scope.kelasiTline_issues = kelasiTline_issues = kelasiTlineIssues.issues()
          scope.kelasi_issues = kelasi_issues = kelasiIssues.issues()
          $q.all([kelasiTline_issues, kelasi_issues]).then ->
            scope.issues_loaded = true
      }
  ]).directive('timelineTimeago', ['timeago', (timeago)->
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
          <div class="col-md-2 center">
              <img class="img-circle inline-profile-photo shadow-centered" ng-src="{{image}}" />
              <div class="vertical-line"></div>
          </div>
          <div class="col-md-10">
            <div class="col-md-12 round5 command-div shadow-downward">
              <img class="my-arrow-box" src="/assets/timeline-images/arrow-box.png" />
              <div class="post-id">
                {{post_id}}
              </div>
              <div class="timeago" timeline-timeago="{{post_time}}"></div>
              <div class="post-message-container" id="message"></div>
              <div class="row" id="rest"></div>
            </div>
          </div>
        </div>'
      replace: true
      scope:
        post: '=timelinePost'
      link: (scope, element, attrs) ->
        scope.$watch 'post.user().picture', (value) ->
          scope.image = value
        scope.$watch 'post.id', (value) ->
          scope.post_id = value
        scope.$watch 'post.updated_at', (value) ->
          scope.post_time = value   
        scope.$watch 'post.msg', (value) ->
          $(element).find('#message').first()
            .html(value)
        replyElement = $(element).find('#rest')
        scope.$watch('post.replies', (v) ->
          replyElement.empty()
          return unless v?
          index = scope.post.replies.length
          while index > 0
            index--
            replyElement.append $("""
              <hr>
              <div class="reply" id="post-#{scope.post.replies[index].id}">
                <div timeline-post="post.replies[#{index}]"></div>
              </div>
            """)
          $compile(replyElement.contents())(scope)
        , true)
    }
  ])
