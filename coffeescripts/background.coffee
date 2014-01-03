###
LinkScan
Background Script

by Mike Green <mike.is.green@gmail.com>
###

# Launch listener - open main window
chrome.app.runtime.onLaunched.addListener ->
  chrome.app.window.create 'main.html',
    bounds:
      width: 800
      height: 600
      left: 100
      top: 100
    minWidth: 800
    minHeight: 600
