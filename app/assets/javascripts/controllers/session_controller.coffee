controllers = angular.module('controllers',[])
controllers.controller("SessionsController", [ '$scope','localStorageService',
  ($scope, localStorageService) ->

    $scope.canGoBigscreen = BigScreen.enabled
    $scope.session = {}
    localStorageService.bind($scope, 'session')

    $scope.newSession = () ->
      BigScreen.toggle()
      logger.push 'toggleFullScreen'
      location.href='#/session/new'

      BigScreen.onexit = () ->
        location.href='#/session/fullscreendisabled'
        logger.push 'exitFullScreen'


    $scope.startSession = () ->
      logger.push 'startSession'
])
