###
LinkScan
Results Controller
###

app = angular.module 'linkScanResults', [ 'ngAnimate' ]

resultsController = ($scope, $location) ->
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

  $scope.pendingStartIndex = _.size($scope.scannedPages) + 1
  $scope.csvString         = createCsvString()

  $scope.saveCsvAs = ->
    csvString = $scope.csvString
    blob      = new Blob [ csvString ], type: 'text/csv'

    chrome.fileSystem.chooseEntry { type: 'saveFile', suggestedName: 'linkscan.csv' }, (entry) ->
      console.debug entry

      chrome.fileSystem.isWritableEntry entry, (writable) ->
        console.debug "Writable: %s", writable

        if writable
          entry.createWriter (writer) ->
            writer.onwriteend = (evt) ->
              console.debug "File saved to %s", entry.name
            writer.onerror    = (err) ->
              console.warn "Error writing to file: %s", e.toString()

            writer.write blob

app.controller 'ResultsController', [ '$scope', '$location', resultsController ]
