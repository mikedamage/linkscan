###
LinkScan
Service Definitions
###

app = angular.module 'linkScanServices', []

app.value 'chromeStorage', chrome.storage.sync
app.value 'chromeNotifications', chrome.notifications
app.value 'chromeFileSystem', chrome.fileSystem

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

app.service 'filesystem', ($rootScope, chromeFileSystem) ->
  @saveFile = (filename, blob, callback) ->
    chromeFileSystem.chooseEntry { type: 'saveFile', suggestedName: filename }, (entry) ->
      console.debug entry

      chromeFileSystem.isWritable entry, (writable) ->
        console.debug "Writable: %s", writable

        if writable
            entry.createWriter (writer) ->
              writer.onwriteend = (evt) ->
                console.debug "File saved to %s", entry.name
              writer.onerror    = (err) ->
                console.warn "Error writing file: %s", err.toString()

              writer.write blob

  @saveTextToFile = (filename, text, mimeType, callback) ->
    blob = new Blob [ text ], type: mimeType
    @saveFile filename, blob, callback

    
