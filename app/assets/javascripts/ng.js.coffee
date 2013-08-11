#= require 'jquery.autosize'
#= require 'jquery.timeago'
#= require_self
#= require 'services/ng.service'
#= require 'filters/ng.filter'
#= require 'directives/ng.directive'
#= require 'controllers/ng.controller'
#= require 'models/ng.model'

@ngapp = angular.module("ngapp", ["ngapp.service", "ngapp.directive", "ngapp.filter", "ngapp.model", "ngCookies"],
  ['$routeProvider', '$locationProvider', '$httpProvider', ($routeProvider, $locationProvider, $httpProvider) ->
    token = $("meta[name='csrf-token']").attr("content")
    $httpProvider.defaults.headers.common["X-CSRF-Token"] = token
    $httpProvider.defaults.headers.common["X-From-Angular"] = 'True'

    $routeProvider.when '/home',
      templateUrl: 'home'
      controller: 'resourcesCtrl'

    $locationProvider.html5Mode on
  ]).run ['$location', ($location) ->
    $location.path '/home'
  ]

