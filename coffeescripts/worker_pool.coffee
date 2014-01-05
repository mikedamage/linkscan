###
LinkScan
Worker Thread Pool
###

class WorkerPool
  constructor: (@poolSize = 4) ->
    @taskQueue   = []
    @workerQueue = []

    @spawnWorkerThread index for index in [1..@poolSize]

  addWorkerTask: (workerTask) ->
    if @workerQueue.length > 0
      # Grab a worker and give it a job
      workerThread = @workerQueue.shift()
      workerThread.run workerTask
    else
      # Otherwise put the task on the queue for the next available worker
      @taskQueue.push workerTask

  spawnWorkerThread: ->
    @workerQueue.push new WorkerThread this

  freeWorkerThread: (workerThread) ->
    if @taskQueue.length > 0
      workerTask = @taskQueue.shift()
      workerThread.run workerTask
    else
      @workerQueue.push workerThread

window.WorkerPool = WorkerPool
