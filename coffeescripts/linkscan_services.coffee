###
LinkScan
Service Definitions
###

app = angular.module 'linkScanServices', []

app.value 'chromeStorage', chrome.storage.sync
app.value 'chromeNotifications', chrome.notifications

# Interface for chrome.storage.sync API
app.service 'storage', ($rootScope, chromeStorage) ->
  @get = (key, done) ->
    chromeStorage.get key, (data) ->
      $rootScope.$apply ->
        done data

  @set = (data, done) ->
    chromeStorage.set data, ->
      $rootScope.$apply done if done
  this

# Interface for chrome.notifications API
app.service 'notifications', ($rootScope, chromeNotifications) ->

  @basic = (opts, done) ->
    timestamp = new Date().getTime()
    nid       = "linkScan_#{timestamp}"
    options   = _.extend {type: 'basic'}, opts

    console.debug options
    chrome.notifications.create nid, options, done

  @scanStart = (url, done) ->
    now = new Date()
    message = "Started scanning #{url}"
    @basic { title: 'Scan Started', message: message }, done

  this
