###
LinkScan
Routing Configuration
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

