###
LinkScan
Results Controller
###

app = angular.module 'linkScanApp', [ 'ngAnimate' ]

resultsController = ($scope) ->
  $scope.results = []

app.controller 'ResultsController', [ '$scope', resultsController ]
