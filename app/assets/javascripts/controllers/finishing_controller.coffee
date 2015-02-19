@controllers.controller("FinishingController", ['$translate','$scope','localStorageService',
  ($translate, $scope, localStorageService) ->
    localStorageService.bind($scope, 'session')

])
