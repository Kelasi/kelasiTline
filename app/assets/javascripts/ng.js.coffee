#= require 'moment'
#= require_self
#= require 'services/ng.service'
#= require 'filters/ng.filter'
#= require 'directives/ng.directive'
#= require 'controllers/ng.controller'
#= require 'models/ng.model'

angular.module("ngapp", ["ngapp.service", "ngapp.directive", "ngapp.filter", "ngapp.model", "ngCookies"])
.config ['$routeProvider', '$locationProvider', '$httpProvider', ($routeProvider, $locationProvider, $httpProvider) ->
    token = $("meta[name='csrf-token']").attr("content")
    $httpProvider.defaults.headers.common["X-CSRF-Token"] = token
    $httpProvider.defaults.headers.common["X-From-Angular"] = 'True'

    $locationProvider.html5Mode on

    $routeProvider
      .when '/home',
        templateUrl: 'home'
        controller: 'resourcesCtrl'
      .otherwise redirectTo: '/home'
  ]

