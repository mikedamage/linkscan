###
LinkScan
Settings Controller
###

app = angular.module 'linkScanSettings', [ 'ngAnimate' ]

settingsController = ($scope, $location, $timeout, storage) ->
  settingsKey = 'linkScanSettings'

  # Default settings
  $scope.settings =
    workerCount: 4
    followRedirects: true
    respectRobotsTxt: true

  $scope.showBanner       = false

  hideBanner   = -> $scope.showBanner = false

  # Load settings from storage
  storage.get settingsKey, (settings) ->
    console.debug 'loaded settings: %O', settings
    if settings.hasOwnProperty settingsKey
      $scope.settings = _.extend $scope.settings, settings[settingsKey]

  $scope.saveSettings = ->
    settings = {}
    settings[settingsKey] = $scope.settings
    storage.set settings, ->
      console.debug 'settings saved: %O', settings
      $scope.showBanner = true
      $timeout hideBanner, 5000, true

app.controller 'SettingsController', [
  '$scope'
  '$location'
  '$timeout'
  'storage'
  settingsController
]

