###
LinkScan
Background URL Fetch Worker
###

fetchURL = (url) ->
  request        = new XMLHttpRequest()
  request.onload = (evt) ->
    xhr     = evt.target
    message =
      status: xhr.status
      statusText: xhr.statusText
      responseText: xhr.responseText
    postMessage message

  request.open 'GET', url
  request.setRequestHeader 'Cache-Control', 'no-cache'
  request.send()

self.onmessage = (evt) ->
  url = evt.data.url
  fetchURL url
