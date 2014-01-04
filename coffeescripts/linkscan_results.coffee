###
LinkScan
Results Controller
###

app = angular.module 'linkScanResults', [ 'ngAnimate' ]

resultsController = ($scope, $location) ->
  console.dir window.location
  console.debug $location.path()

  $scope.results = []

  $scope.isActive = (path) -> $location.path() is path
  $scope.openPath = (path) -> $location.path path

app.controller 'ResultsController', [ '$scope', '$location', resultsController ]
