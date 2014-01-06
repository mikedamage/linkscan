###
LinkScan
Worker Thread Class
###

class WorkerThread
  constructor: (@id, @parentPool) ->
    @workerTask = {}
    @running    = false
    @worker     = null

  run: (workerTask) ->
    @workerTask = workerTask

    if @workerTask.script?
      @running = true
      @worker = new Worker @workerTask.script
      @worker.addEventListener 'message', @passCallback, false
      @worker.postMessage @workerTask.startMessage

  passCallback: (evt) =>
    @workerTask.callback(evt)
    @parentPool.freeWorkerThread this

  killWorker: ->
    @running = false
    @worker.terminate()


window.WorkerThread = WorkerThread
