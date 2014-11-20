controllers = angular.module('controllers',[])
controllers.controller("SessionsController", [ '$scope','localStorageService',
  ($scope, localStorageService) ->

    $scope.canGoBigscreen = BigScreen.enabled
    $scope.session = {}
    localStorageService.bind($scope, 'session')

    $scope.goToInstruction1 = () ->

      #unless BigScreen.element
      #  BigScreen.toggle()

      logger.push 'toggleFullScreen'
      location.href='#/session/instruction_1'
      logger.push 'Show instruction 1'

      $(document).unbind('keydown')
      $(document).keydown (e) ->
        if e.keyCode is 39
          $scope.gotToInstruction_1_1()
        e.preventDefault()
      true

    $scope.gotToInstruction_1_1 = () ->
      location.href='#/session/instruction_1_1'
      logger.push 'Show instruction 1_1'

      $(document).unbind('keydown')
      $(document).keydown (e) ->
        if e.keyCode is 37
          $scope.goToInstruction1()
        e.preventDefault()
      true

    $scope.startSession = () ->
      logger.push 'startSession'
])
