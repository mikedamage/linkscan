###
LinkScan
Background Script

by Mike Green <mike.is.green@gmail.com>
###

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
