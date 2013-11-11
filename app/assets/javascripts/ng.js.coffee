#= require 'moment'
#= require 'store'
#= require_self
#= require 'flipload'
#= require 'jquery.sticky'
#= require 'services/ng.service'
#= require 'filters/ng.filter'
#= require 'directives/ng.directive'
#= require 'controllers/ng.controller'
#= require 'models/ng.model'

angular.module("ngapp", ["ngapp.service", "ngapp.directive", "ngapp.filter", "ngapp.model", "ngRoute"])
.config(['$routeProvider', '$locationProvider', '$httpProvider'
  ($routeProvider, $locationProvider, $httpProvider) ->

    token = $("meta[name='csrf-token']").attr("content")
    $httpProvider.defaults.headers.common["X-CSRF-Token"] = token
    $httpProvider.defaults.headers.common["X-From-Angular"] = 'True'
    $httpProvider.defaults.headers.common["X-Requested-With"] = 'XMLHttpRequest'

    $locationProvider.html5Mode on

    $routeProvider
      .when '/home',
        templateUrl: 'home'
        controller: 'resourcesCtrl'
      .otherwise redirectTo: '/home'
  ])
.run ['$templateCache', '$http', ($templateCache, $http) ->
    home_template = store.get 'home_template'
    if home_template?
      $templateCache.put 'home', home_template
      $http.get('/home').then (v) -> $templateCache.put 'home', v
]

