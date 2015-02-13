@controllers.controller("SessionsController", ['$translate','$scope','localStorageService',
  ($translate, $scope, localStorageService) ->

    $scope.canGoBigscreen = BigScreen.enabled
    localStorageService.bind($scope, 'session')
    $scope.session = {}
    $scope.session.language = $translate.use()

    $scope.ToggleBigScreen = () ->
      BigScreen.toggle()
      logger.push 'toggleFullScreen'
      $scope.GoToInstruction1()

    $scope.GoToInstruction1 = () ->
      # Trying to hide the cursor for now
      $('body').addClass('no-cursor')

      location.href='#/session/instruction_1'
      logger.push 'Show instruction 1'

      $(document).unbind('keydown')
      $(document).keydown (e) ->
        # Right arrow pressed
        if e.keyCode is 39
          $scope.GotToInstruction_1_1()
        e.preventDefault()
      true

    $scope.GotToInstruction_1_1 = () ->
      location.href='#/session/instruction_1_1'
      logger.push 'Show instruction 1_1'

      $(document).unbind('keydown')
      $(document).keydown (e) ->
        # Left arrow pressed
        if e.keyCode is 37
          $scope.GoToInstruction1()
        e.preventDefault()
      true

    $scope.ChangeLanguage = () ->
      if $translate.use() == 'de'
        $translate.use 'en'
      else
        $translate.use 'de'
      $scope.session.language = $translate.use()
      logger.push 'Switch language to ' + $translate.use()
])
