controllers = angular.module('controllers',[])
controllers.controller("SessionsController", [ '$scope',
  ($scope)->
    $scope.canGoBigscreen = BigScreen.enabled
    $scope.age = null

    $scope.newSession = () ->
      BigScreen.toggle()
      location.href='#/session/new'

      BigScreen.onexit = () ->
        location.href='#/session/fullscreendisabled'


    $scope.startSession = () ->
      alert('start Session now')
])
