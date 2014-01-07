###
LinkScan
Background Script

by Mike Green <mike.is.green@gmail.com>
###

window.settingsKey = 'linkScanSettings'
window.settings    = {}
window.workerPool  = {}

# Launch listener - open main window
chrome.app.runtime.onLaunched.addListener ->
  chrome.app.window.create 'main.html',
    bounds:
      width: 1024
      height: 768
      left: 100
      top: 100
    minWidth: 800
    minHeight: 600

  # Load settings and instantiate worker pool
  chrome.storage.sync.get settingsKey, (settings) ->
    window.settings   = settings[settingsKey]
    workerCount       = window.settings.workerCount || 6
    window.workerPool = new WorkerPool workerCount

  # Respond to asynchronous messages passed from app window
  chrome.runtime.onMessage.addListener (message, sender, sendResponse) ->
    methods =
      reloadSettings: ->
        chrome.storage.sync.get window.settingsKey, (settings) ->
          window.settings = settings[settingsKey]
          sendResponse message: "Settings reloaded", settings: settings
      refreshWorkerPool: ->
        window.workerPool.terminate()
        window.workerPool = new WorkerPool window.settings.workerCount
        sendResponse message: "Killed and restarted #{window.settings.workerCount} workers"

    if methods.hasOwnProperty message.method
      methods[message.method]()
      true

