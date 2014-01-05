###
LinkScan
Navigation Control
###

app = angular.module 'linkScanNavigation', []

navigationController = ($scope, $location) ->
  $scope.isActive = (path) -> $location.path() is path
  $scope.openPath = (path) -> $location.path path

app.controller 'NavigationController', [ '$scope', '$location', navigationController ]

