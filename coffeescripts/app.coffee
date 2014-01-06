###
LinkScan
Routing Configuration
###

###
= require "../bower_components/underscore/underscore-min.js"
= require "../bower_components/spin.js/spin.js"
= require "../bower_components/bootstrap/dist/bootstrap.min.js"
= require "../bower_components/angular/angular.min.js"
= require "../bower_components/angular-animate/angular-animate.min.js"
= require "../bower_components/angular-route/angular-route.min.js"
= require "./worker_thread.js"
= require "./worker_task.js"
= require "./worker_route.js"
= require "./linkscan_navigation.js"
= require "./linkscan_services.js"
= require "./linkscan_home.js"
= require "./linkscan_results.js"
= require "./linkscan_settings.js"
###

app = angular.module 'linkScanApp', [
  'ngRoute'
  'linkScanNavigation'
  'linkScanHome'
  'linkScanResults'
  'linkScanSettings'
  'linkScanServices'
]

app.config ($compileProvider, $routeProvider, $locationProvider) ->

  $compileProvider.aHrefSanitizationWhitelist /^\s*(https?|ftp|mailto|chrome-extension):/

  $routeProvider.when '/',
    templateUrl: 'templates/scan.html'
    controller: 'ScanController'

  $routeProvider.when '/results',
    templateUrl: 'templates/results.html'
    controller: 'ResultsController'

  ###
  $routeProvider.when '/saved',
    templateUrl: 'saved.html'
    controller: 'SavedController'
  ###

  $routeProvider.when '/settings',
    templateUrl: 'templates/settings.html'
    controller: 'SettingsController'

  # Default route
  $routeProvider.otherwise redirectTo: '/'

  $locationProvider.html5Mode true

