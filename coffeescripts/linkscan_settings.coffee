###
LinkScan
Settings Controller
###

app = angular.module 'linkScanSettings', [ 'ngAnimate' ]

settingsController = ($scope, $location, $storage) ->
  $scope.workerCount      = 4
  $scope.followRedirects  = true
  $scope.showBanner       = false
  $scope.respectRobotsTxt = true

  hideBanner = -> $scope.showBanner = false

  $scope.saveSettings = ->
    settings =
      workerCount: $scope.workerCount
      followRedirects: $scope.followRedirects
      respectRobotsTxt: $scope.respectRobotsTxt
    $storage.set settings, ->
      $scope.success()

  $scope.success = ->
    $scope.showBanner = true
    $timeout hideBanner, 5000, true

app.controller 'SettingsController', [
  '$scope'
  '$location'
  #'$storage'
  settingsController
]

