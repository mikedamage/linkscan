###
LinkScan
Results Controller
###

app = angular.module 'linkScanResults', [ 'ngAnimate' ]

resultsController = ($scope, $location) ->
  $scope.results = []

app.controller 'ResultsController', [ '$scope', '$location', resultsController ]
