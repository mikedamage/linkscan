###
LinkScan
Settings Controller
###

app = angular.module 'linkScanSettings', [ 'ngAnimate' ]

settingsController = ($scope, $location) ->
  $scope.workerCount     = 4
  $scope.followRedirects = true
  $scope.showBanner      = false

  hideBanner = -> $scope.showBanner = false

  $scope.isActive = (path) -> $location.path() is path

  $scope.saveSettings = ->
    chrome.storage.local.set settings, ->
      $scope.success()

  $scope.success = ->
    $scope.showBanner = true
    $timeout hideBanner, 5000, true

app.controller 'SettingsController', [ '$scope', '$location', settingsController ]

