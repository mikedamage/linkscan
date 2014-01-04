###
LinkScan
Settings Controller
###

app = angular.module 'linkScanApp', [ 'ngAnimate' ]

settingsController = ($scope) ->
  $scope.workerCount     = 4
  $scope.followRedirects = true
  $scope.showBanner      = false

  hideBanner = -> $scope.showBanner = false

  $scope.saveSettings = ->
    chrome.storage.local.set settings, ->
      $scope.success()

  $scope.success = ->
    $scope.showBanner = true
    $timeout hideBanner, 5000, true

app.controller 'SettingsController', [ '$scope', settingsController ]

