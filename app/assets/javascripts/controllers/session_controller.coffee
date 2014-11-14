controllers = angular.module('controllers',[])
controllers.controller("SessionsController", [ '$scope',
  ($scope)->
    $scope.canGoBigscreen = BigScreen.enabled

    $scope.startSession = () ->
      #BigScreen.toggle()
      location.href='#/session/new'
])
