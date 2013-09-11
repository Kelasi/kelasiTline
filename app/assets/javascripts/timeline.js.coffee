#= require 'moment'
#= require_self
#= require 'store'
#= require 'services/timeline.service'
#= require 'directives/timeline.directive'
#= require 'filters/timeline.filter'
#= require 'models/timeline.model'
#= require 'controllers/timeline.controller'

angular.module("timeline", ["timeline.service", "timeline.directive", "timeline.filter", "timeline.model"])
.config ['$routeProvider', '$locationProvider', '$httpProvider', ($routeProvider, $locationProvider, $httpProvider) ->
    token = $("meta[name='csrf-token']").attr("content")
    $httpProvider.defaults.headers.common["X-CSRF-Token"] = token
  ]
