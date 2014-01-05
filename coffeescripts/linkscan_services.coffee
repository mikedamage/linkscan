###
LinkScan
Service Definitions
###

app = angular.module 'linkScanServices', []

app.value 'chromeStorage', chrome.storage.sync

app.service 'storage', ($rootScope, chromeStorage) ->
  @get = (key, done) ->
    chromeStorage.get key, (data) ->
      $rootScope.$apply ->
        done data

  @set = (data, done) ->
    chromeStorage.set data, ->
      $rootScope.$apply done if done
  this
