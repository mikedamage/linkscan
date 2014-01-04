###
LinkScan
Routing Configuration
###

app = angular.module 'linkScanApp', [
  'ngRoute'
  'linkScanHome'
  'linkScanResults'
  'linkScanSettings'
]

app.config ($compileProvider, $routeProvider, $locationProvider) ->
  $routeProvider.when '/scan',
    templateUrl: 'scan.html'
    controller: 'ScanController'

  $routeProvider.when '/results',
    templateUrl: 'results.html'
    controller: 'ResultsController'

  ###
  $routeProvider.when '/saved',
    templateUrl: 'saved.html'
    controller: 'SavedController'
  ###

  $routeProvider.when '/settings',
    templateUrl: 'settings.html'
    controller: 'SettingsController'

  # Default route
  $routeProvider.otherwise redirectTo: '/scan'

  $locationProvider.html5Mode true

