###
LinkScan
Background Script

by Mike Green <mike.is.green@gmail.com>
###

# Evil globals
# [todo] - Make these non-global when you're done debugging.
window.settings    = {}
window.workerPool  = {}
window.crawledUrls = {}
window.pendingUrls = {}

# Variables available to all callbacks
settingsKey  = 'linkScanSettings'

helpers =
  isHTML: (contentType) -> /x?html/.test contentType
  isAbsoluteUrl: (url) -> /^https?:\/\//.test url
  isAbsolutePath: (path) -> /^\//.test url
  convertToAbsolute: (parentUrl, url) ->
    return url if helpers.isAbsoluteUrl url
    
    uri        = new URI url
    parentUri  = new URI parentUrl

    if helpers.isAbsolutePath url
      uri.relativeTo(parentUri).toString()
    else
      uri.absoluteTo(parentUri).toString()
    
crawlLinksRecursively = (evt) ->
  data = evt.data
  pageBase =
    success: false
    warning: false
    error: false
    status: data.status
    detailMessage: data.statusText
    appearsOn: [ data.url ]

  if data.status >= 400
    _.extend pageBase, error: true
  else if data.status >= 200 and data.status < 300
    _.extend pageBase, success: true

  # Remove URL from pending list and add it to completed list
  delete window.pendingUrls[data.url]
  window.crawledUrls[data.url] = page

  parseAndCrawlDocument data.url, data.responseText if helpers.isHTML data.contentType
  true

parseAndCrawlDocument = (url, text) ->
  container           = document.createElement 'div'
  container.innerHTML = text
  links               = container.getElementsByTagName 'a'

  _.each links, (link, index) ->
    fullUrl = helpers.convertToAbsolute url, link.href

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
        chrome.storage.sync.get settingsKey, (settings) ->
          window.settings = settings[settingsKey]
          sendResponse message: "Settings reloaded", settings: settings
      refreshWorkerPool: ->
        window.workerPool.killAllWorkers ->
          window.workerPool.spawnAllWorkers()
          sendResponse message: "Killed and restarted #{window.settings.workerCount} workers"
      startScan: ->
        task = new WorkerTask 'javascripts/background_worker.js', { url: message.startUrl }, crawlLinksRecursively
        window.workerPool.addWorkerTask task
        sendResponse message: "Started scanning #{message.startUrl}"

    if message.hasOwnProperty('method') and methods.hasOwnProperty(message.method)
      methods[message.method]()
    else
      sendResponse message: "Invalid or missing method name!"
    true

