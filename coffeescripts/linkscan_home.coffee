###
LinkScan
Scan Controller
###

app = angular.module 'linkScanHome', [ 'ngAnimate' ]

scanController = ($scope, $location) ->
  $scope.url             = ''
  $scope.followRedirects = true
  $scope.workerCount     = 4

  $scope.isActive = (path) -> $location.path() is path
  $scope.openPath = (path) -> $location.path path

app.controller 'ScanController', [ '$scope', '$location', scanController ]
