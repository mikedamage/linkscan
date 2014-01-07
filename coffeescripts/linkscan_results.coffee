###
LinkScan
Results Controller
###

app = angular.module 'linkScanResults', [ 'ngAnimate' ]

resultsController = ($scope, $location, filesystem) ->
  createCsvString = ->
    csvString = '"URL","Status","Appears On"' + "\n"
    _.each $scope.scannedPages, (val, key, list) ->
      csvString += "\"#{key}\",\"#{val.status}\",\"#{val.appearsOn.join("\\n")}\"\n"
    csvString

  createDataURI = (string, mimeType) ->
    uri = "data:#{mimeType};base64,"
    uri += btoa string

  # MOCK DATA
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
  # END MOCK DATA

  $scope.scannedUrlCount   = _.size $scope.scannedPages
  $scope.pendingUrlCount   = _.size $scope.pendingPages
  $scope.pendingStartIndex = $scope.scannedUrlCount + 1

  # Watch $scope.scannedPages for changes and update URL count
  $scope.$watchCollection 'scannedPages', (newProps, oldProps) ->
    $scope.scannedUrlCount   = _.size newProps
    $scope.pendingStartIndex = $scope.scannedUrlCount + 1

  $scope.$watchCollection 'pendingPages', (newVal, oldVal) ->
    $scope.pendingUrlCount = _.size newVal

  $scope.saveCsvAs = ->
    csvString = createCsvString()

    filesystem.saveTextToFile 'linkscan.csv', 'text/csv', csvString, (evt) ->
      console.log evt

app.controller 'ResultsController', [
  '$scope'
  '$location'
  'filesystem'
  resultsController
]
