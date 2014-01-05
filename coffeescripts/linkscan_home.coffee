###
LinkScan
Scan Controller
###

app = angular.module 'linkScanHome', [ 'ngAnimate' ]

scanController = ($scope, $location, storage, notifications) ->
  settingsKey              = 'linkScanSettings'
  $scope.url               = ''
  $scope.basicAuthUsername = ''
  $scope.basicAuthPassword = ''
  $scope.settings          = {}

  # Load settings
  storage.get settingsKey, (settings) ->
    console.debug 'Loaded settings: %O', settings
    if settings.hasOwnProperty settingsKey
      $scope.settings = _.extend $scope.settings, settings[settingsKey]

  $scope.startScan = ->
    console.debug 'Scan started for URL: %s', $scope.url
    #notifications.scanStart $scope.url, -> console.debug 'notification callback'

app.controller 'ScanController', [
  '$scope'
  '$location'
  'storage'
  'notifications'
  scanController
]
