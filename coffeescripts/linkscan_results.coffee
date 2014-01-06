###
LinkScan
Results Controller
###

app = angular.module 'linkScanResults', [ 'ngAnimate' ]

resultsController = ($scope, $location) ->
  $scope.scannedPages =
    'http://google.com/':
      success: true
      warning: false
      error: false
      status: 200
      appearsOn: [ 'http://google.com/home.html', 'http://google.com/weird.html' ]
      detailMessage: 'OK'
    'http://google.com/foogle.html':
      success: false
      warning: false
      error: true
      status: 404
      appearsOn: [ 'http://google.com/', 'http://google.com/weird.html' ]
      detailMessage: 'Not Found'

  $scope.pendingPages = [
    'http://google.com/bar.html'
    'http://google.com/foo.html'
  ]
  $scope.pendingStartIndex = _.size($scope.scannedPages) + 1

  createCSVString = ->
    csvString = '"URL","Status","Appears On"' + "\n"
    _.each $scope.scannedPages, (val, key, list) ->
      csvString += "\"#{key}\",\"#{val.status}\",\"#{val.appearsOn.join("\\n")}\"\n"
    csvString

  createDataURI = (string, mimeType) ->
    uri = "data:#{mimeType};base64,"
    uri += btoa string

  createObjectURL = (string, mimeType) ->
    blob = new Blob [ string ], type: mimeType
    window.URL.createObjectURL blob

  $scope.csvDownloadURI = createObjectURL createCSVString()

app.controller 'ResultsController', [ '$scope', '$location', resultsController ]
