

ngapp_service = angular.module("ngapp.service", [])


class Notification
  constructor: (@timeout, @q) ->

  loading: (promise) ->
    @timeout.cancel @timeoutId if @timeoutId?

    @timeoutId = @timeout( ->
      $('.alert-box').slideDown()
    , 750)

    promise.then =>
      if @timeoutId?
        @timeout.cancel @timeoutId
        @timeoutId = null
      else
        @timeout( ->
          $('.alert-box').slideUp()
        , 500)


ngapp_service.factory("notification",
  ['$timeout', '$q', ($timeout, $q) ->
    new Notification $timeout, $q
  ]
)

ngapp_service.factory("utilities", 
  [ '$timeout', '$http', '$q', ($timeout, $http, $q) ->
    return {
      initialization: ->
        $timeout -> $timeout ->
          $('#all-posts time.timeago').timeago()
          $('textarea').autosize {append: "\n"}
          $('textarea').css 'resize', 'vertical'
    }
  ]
)
