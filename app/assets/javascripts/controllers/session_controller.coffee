@controllers.controller("SessionsController", ['$translate','$scope','localStorageService','$timeout','$routeParams',
  ($translate, $scope, localStorageService, $timeout, $routeParams) ->

    $scope.canGoBigscreen = BigScreen.enabled
    localStorageService.bind($scope, 'session')
    $scope.session = {} unless $scope.session

    $translate.use($routeParams.language) unless angular.isUndefined($routeParams.language)

    $scope.session.language = $translate.use()
    $scope.session.trial_counter = 0
    $scope.session.show_informed_consent = true
    $scope.error_message = ''
    $scope.session_id = ''

    if $scope.session.started == true
      localStorage.clear()
      location.href='#/session/test_already_started'

    $scope.ShowErrorMessage = () ->
      $scope.error_message != ''

    $scope.ShowInformedConsent = () ->
      $scope.session.show_informed_consent

    $scope.ShowWarning = () ->
      logger.push 'accepted informed consent'

      logger.push 'Push data'

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
        system_information: system_informations
        language: $scope.session.language

      $.post('/sessions',{ session: data }).done( (data)->
          logger.push 'Done sending data'
          $scope.session_id = data._id.$oid
          $timeout ( -> $scope.session.show_informed_consent = false ), 0
          $scope.error_message = ''
        ).fail (jqxhr, textStatus, error)->
          logger.push 'failed send data '  + textStatus + ', ' + error + ', ' + jqxhr.responseText
          $timeout ( -> $scope.session.show_informed_consent = true ), 0
          $scope.error_message = 'Request Failed: ' + textStatus + ', ' + error

    $scope.ToggleBigScreen = () ->
      BigScreen.toggle()
      $timeout ( -> $scope.PrepareTest() ), 0
      $timeout ( -> $scope.GoToInstruction1() ), 0
      logger.push 'toggle fullscreen'
      true

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

    $scope.GotToInstruction_1_1 = () ->
      location.href='#/session/instruction_1_1'
      logger.push 'Show instruction 1_1'

      $(document).unbind('keydown')
      $(document).keydown (e) ->
        # Left arrow pressed
        if e.keyCode is 37
          $scope.GoToInstruction1()
        if e.keyCode is 39
          location.href='#/test'
        e.preventDefault()

    $scope.ChangeLanguage = () ->
      if $translate.use() == 'de'
        $translate.use 'en'
      else
        $translate.use 'de'
      $scope.session.language = $translate.use()
      logger.push 'Switch language to ' + $translate.use()

    $scope.PrepareTest = () ->
      $scope.session = { id: $scope.session_id }

      # Let's get a shuffled stack of words
      word_stack = window['words_' + $translate.use()]
      word_stack.shuffle()

      # The final delay condition randomly selected
      final_delay = [200, 1500].shuffle()[0]

      # The middle delay condition is randomly selected within the two possibilities of distribution for 11 trials (5, 6 vs 6, 5)
      middle_delays =[
        [200, 200, 200, 200, 200, 200, 1500, 1500, 1500, 1500, 1500].shuffle()
        [200, 200, 200, 200, 200, 1500, 1500, 1500, 1500, 1500, 1500].shuffle()
      ].shuffle()[0]

      # Shuffle an array with delay conditions. Ensure the first two includes each condition in a random order
      word_delays = [200, 1500].shuffle().concat(middle_delays).concat(final_delay)

      # Generate an array of trials containing the words that we complete later during the test
      $scope.session.trials = []
      word_counter = 0

      for number_of_trials in [1..14]
        words = []
        retrievals = []

        # Shuffle the color for each trial
        word_colors = ['red', 'red', 'red', 'red', 'red', 'blue', 'blue', 'blue', 'blue', 'blue'].shuffle()

        # Get word delay condition for each trial
        word_delay = word_delays[number_of_trials - 1]

        for number_of_words in [1..10]
          word =  word_stack[word_counter]
          word.color = word_colors[number_of_words - 1]
          word.delay = if word.color == 'red' then 200 else word_delay
          word.trial = number_of_trials
          word.word_position = number_of_words
          # Add words for each trial
          words.push word

          # Push cloned words also to the retrievals
          retrievals.push JSON.parse(JSON.stringify word)
          word_counter++

        # Add some additional words in the retrievals not presented before
        for number_of_words_not_presented in [1..5]
          word = word_stack[word_counter]
          word.trial = number_of_trials
          retrievals.push word
          word_counter++

        # Shuffle the retrievals and update the position
        retrievals.shuffle()

        for number_of_retrievals in [1..retrievals.length]
          retrievals[number_of_retrievals - 1 ].retrieval_position = number_of_retrievals

        $scope.session.trials.push { words: words, retrievals: retrievals, word_delay: word_delay, retrieval_clicks: [], repeated: false }
])
