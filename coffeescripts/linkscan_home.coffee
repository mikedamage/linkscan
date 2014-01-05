###
LinkScan
Scan Controller
###

app = angular.module 'linkScanHome', [ 'ngAnimate' ]

scanController = ($scope, $location) ->
  $scope.url             = ''
  $scope.followRedirects = true
  $scope.workerCount     = 4

app.controller 'ScanController', [ '$scope', '$location', scanController ]
