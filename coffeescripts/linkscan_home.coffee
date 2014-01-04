###
LinkScan
Scan Controller
###

app = angular.module 'linkScanHome', [ 'ngAnimate' ]

scanController = ($scope, $location) ->
  console.dir window.location
  console.debug $location.path()

  $scope.url             = ''
  $scope.followRedirects = true
  $scope.workerCount     = 4

  $scope.isActive = (path) -> $location.path() is path
  $scope.openPath = (path) -> console.debug $location.path path

app.controller 'ScanController', [ '$scope', '$location', scanController ]
