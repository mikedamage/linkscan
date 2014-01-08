###
LinkScan
Worker Thread Pool
###

class WorkerPool
  constructor: (@poolSize = 4) ->
    @taskQueue   = []
    @workerQueue = []
    @busyWorkers = []
    @killBusyWorkersWhenDone = false
    @workerCount = 0

    @spawnWorkerThread index for index in [1..@poolSize]

  addWorkerTask: (workerTask) ->
    if @workerQueue.length > 0
      # Grab a worker and give it a job
      workerThread = @workerQueue.shift()
      workerThread.run workerTask
    else
      # Otherwise put the task on the queue for the next available worker
      @taskQueue.push workerTask

  spawnWorkerThread: (idx) ->
    @workerCount += 1
    @workerQueue.push new WorkerThread idx, this

  spawnAllWorkers: ->
    @spawnWorkerThread index for index in [1..@poolSize]
    @workerQueue

  # Only runs allKilledCallback when @workerCount == 0
  killWorkerThread: (allKilledCallback = $.noop) ->
    if @workerQueue.length > 0
      @workerCount -= 1
      @workerQueue.shift().killWorker()
      allKilledCallback.call this if @workerCount is 0

  killAllWorkers: (allKilledCallback) ->
    @killWorkerThread allKilledCallback for thread in @workerQueue
    @killBusyWorkersWhenDone = true

  freeWorkerThread: (workerThread) ->
    if @killBusyWorkersWhenDone
      workerThread.killWorker()
      @workerQueue.push workerThread
    else
      if @taskQueue.length > 0
        workerTask = @taskQueue.shift()
        workerThread.run workerTask
      else
        @workerQueue.push workerThread

window.WorkerPool = WorkerPool
