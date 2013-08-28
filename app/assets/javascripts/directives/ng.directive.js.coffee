

angular.module("ngapp.directive", [])
  .directive 'ngappNotify', ->
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

