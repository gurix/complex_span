controllers = angular.module('controllers',[])
controllers.controller("SessionsController", [ '$scope',
  ($scope)->
    $scope.canGoBigscreen = BigScreen.enabled
    $scope.age = null

    $scope.newSession = () ->
      #BigScreen.toggle()
      location.href='#/session/new'

    $scope.startSession = () ->
      alert('start Session now')
])
