###
LinkScan
Settings Controller
###

app = angular.module 'linkScanSettings', [ 'ngAnimate' ]

settingsController = ($scope, $location, $timeout, storage) ->
  settingsKey = 'linkScanSettings'

  # Default settings
  $scope.workerCount      = 4
  $scope.followRedirects  = true
  $scope.respectRobotsTxt = true

  $scope.showBanner       = false

  hideBanner   = -> $scope.showBanner = false

  # Load settings from storage
  storage.get settingsKey, (settings) ->
    console.debug settings
    if settings.hasOwnProperty settingsKey
      settings                = settings[settingsKey]
      $scope.workerCount      = settings.workerCount
      $scope.followRedirects  = settings.followRedirects
      $scope.respectRobotsTxt = settings.respectRobotsTxt

  $scope.saveSettings = ->
    settings = {}
    settings[settingsKey] =
      workerCount: $scope.workerCount
      followRedirects: $scope.followRedirects
      respectRobotsTxt: $scope.respectRobotsTxt
    storage.set settings, ->
      console.debug 'settings saved'
      $scope.showBanner = true
      $timeout hideBanner, 5000, true

app.controller 'SettingsController', [
  '$scope'
  '$location'
  '$timeout'
  'storage'
  settingsController
]

