###
LinkScan
Worker Thread Class
###

class WorkerThread
  constructor: (@parentPool) ->
    @workerTask = {}

  run: (workerTask) ->
    @workerTask = workerTask

    if @workerTask.script?
      worker = new Worker @workerTask.script
      worker.addEventListener 'message', @passCallback, false
      worker.postMessage @workerTask.startMessage

  passCallback: (evt) ->
    @workerTask.callback(evt)
    @parentPool.freeWorkerThread this

window.WorkerThread = WorkerThread
