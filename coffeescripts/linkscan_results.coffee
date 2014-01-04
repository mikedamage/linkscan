###
LinkScan
Results Controller
###

app = angular.module 'linkScanResults', [ 'ngAnimate' ]

resultsController = ($scope, $location) ->
  $scope.results = []

  $scope.isActive = (path) -> $location.path() is path
  $scope.openPath = (path) -> $location.path path

app.controller 'ResultsController', [ '$scope', '$location', resultsController ]
