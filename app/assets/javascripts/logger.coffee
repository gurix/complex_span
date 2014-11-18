class window.Logger

  @log = []

  constructor: () ->
    @getFromLocalStroage()

  push: (message) ->
    @getFromLocalStroage()
    @log.push({time: Date.now(), message: message})
    console.log message
    @saveLocalStorage()

  clear: () ->
    @log = []
    @saveLocalStorage()

  getFromLocalStroage: () ->
    @log = JSON.parse(localStorage.getItem('log')) || []

  saveLocalStorage: () ->
    localStorage.setItem('log', JSON.stringify(@log))
