

ngapp_service = angular.module("ngapp.service", [])


class Notification
  constructor: (@timeout, @q) ->

  timeoutId: null
  jobs: []

  clean: ->
    @timeout.cancel @timeoutId if @timeoutId?
    @timeoutId = null
    $('.alert-box').slideUp()

  check: ->
    if (0 for j in @jobs when j.done).length
      @jobs = []
      @clean()

  loading: (promise) ->
    @timeoutId = @timeout( (-> $('.alert-box').slideDown()) , 750)

    @jobs.push job = done: no
    promise.then =>
      job.done = yes
      promise


ngapp_service.factory("notification",
  ['$timeout', '$q', ($timeout, $q) ->
    new Notification $timeout, $q
  ]
)

ngapp_service.factory("utilities", 
  [ '$timeout', '$http', '$q', 'notification'
  ($timeout, $http, $q, notification) ->
    return {
      initialization: ->
        $('#all-posts time.timeago').timeago()
        $('textarea').autosize( append: "\n" )
          .css 'resize', 'vertical'
        notification.check()
    }
  ]
)
