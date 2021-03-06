@controllers.controller("FinishingController", ['$translate','$scope','localStorageService','$timeout',
  ($translate, $scope, localStorageService, $timeout) ->
    localStorageService.bind($scope, 'session')

    BigScreen.onexit = () ->
        logger.push 'Exit fullscreen'

    $('body').removeClass('no-cursor')

    $scope.error_message = ''
    $scope.show_debriefing = false
    $scope.show_form = true

    $scope.ShowDebriefing = () ->
      $scope.show_debriefing

    $scope.ShowForm = () ->
      $scope.show_form

    $scope.ShowErrorMessage = () ->
      $scope.error_message != ''

    $scope.ClickSendData = () ->
      logger.push 'Update data'

      # Gather some information about the client
      system_informations =
        screen_width: screen.width
        screen_height: screen.height
        navigator_user_agent: navigator.userAgent
        navigator_platform: navigator.platform
        window_innerHeight: window.innerHeight
        window_innerWidth: window.innerWidth
        window_screenX: window.screenX
        window_screenY: window.screenY
        window_pageXOffset: window.pageXOffset
        window_pageYOffset: window.pageYOffset

      data =
        logs: logger.log
        trials: $scope.session.trials
        sincerity: $scope.session.sincerity
        age: $scope.session.age
        gender: $scope.session.gender
        education: $scope.session.education
        mturkid: $scope.session.mturkid
        system_information: system_informations
        language: $scope.session.language

      $scope.show_form = false

      $.ajax("/sessions/#{$scope.session.id}", { method: 'PATCH', data: { session: data }}).done( ->
          logger.push 'Done sending data'
          $timeout (-> $scope.show_debriefing = true), 0
          $scope.error_message = ''
          localStorage.clear()
        ).fail (jqxhr, textStatus, error)->
          logger.push 'failed send data '  + textStatus + ', ' + error + ', ' + jqxhr.responseText
          $timeout (-> $scope.show_form = true), 0

          $scope.error_message = 'Request Failed: ' + textStatus + ', ' + error
          console.log $scope.error_message
])
