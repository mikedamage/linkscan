###
LinkScan
Scan Controller
###

app = angular.module 'linkScanApp', [ 'ngAnimate' ]

scanController = ($scope) ->
  $scope.url             = ''
  $scope.followRedirects = true
  $scope.workerCount     = 4

app.controller 'ScanController', [ '$scope', scanController ]
