@controllers.controller("TrialsController", ['$translate','$scope','localStorageService','$timeout'
  ($translate, $scope, localStorageService, $timeout) ->

    $scope.session = {}
    localStorageService.bind($scope, 'session')
    $scope.show_word = false
    $scope.show_fixation_point = true
    $scope.session.trial_counter = 0
    $scope.session.word_counter = 0
    $scope.number_of_trials = 14
    $scope.number_of_words_per_trial = 10

    $scope.ShowFixationPoint = () ->
      $scope.show_fixation_point

    $scope.CurrentWord = () ->
      $scope.session.trials[$scope.session.trial_counter].words[$scope.session.word_counter].word

    $scope.ShowWord = () ->
      $scope.show_word

    $scope.PrepareTest = () ->
      # Let's get a shuffled stack of words
      word_stack = window['words_' + $translate.use()]
      word_stack.shuffle()

      # We have two collors
      word_colors = [1, 1, 1, 1, 1, 2, 2, 2, 2, 2]

      # Generate an array of trials containing the words that we complete later during the test
      $scope.session.trials = []
      i = 0
      for number_of_trials in [1..$scope.number_of_trials]
        word_colors.shuffle() # Shuffle word colors for each trial
        words = []
        for number_of_words in [1..$scope.number_of_words_per_trial]
          words.push new window.Word(number_of_trials, number_of_words, word_stack[i], word_colors[number_of_words - 1])
          i++
        $scope.session.trials.push { words: words, selections: [] } # implement selections later here

      # Start the first trials
      $scope.StartTrial()

    $scope.StartTrial = () ->
      logger.push 'Start with trial ' + $scope.session.trial_counter

      # Show fixation point
      $scope.show_fixation_point = true

      # Start with the first word, delay of 500ms
      $timeout (-> $scope.DisplayWord()), 500

    $scope.DisplayWord = () ->
      logger.push 'Display word ' + $scope.session.word_counter + ' in trial ' + $scope.session.trial_counter

      # Ensure fixation point is hidden
      $scope.show_fixation_point = false

      # Ensure word will be shown
      $scope.show_word = true

      # Remember the time when the current word is displayed
      $scope.CurrentWord().start_time = new Date()

      # Display the word for 2000ms, otherwise it will move to the next word
      next_word = $timeout (-> $scope.NextWord()), 2000

      # Detect keydown event
      # Ensure we unbind the keydown event
      $(document).unbind('keydown')
      $(document).keydown (e) ->

        # It must be left or right
        if (e.keyCode == 39 || e.keyCode == 37)
          logger.push 'Pressed key ' + e.keyCode

          # The timeout has to be canceled because we move on to the next word manually
          $timeout.cancel next_word

          # We emidiatly move on to the next word once left or right was pressed
          $scope.NextWord()
        else
          logger.push 'Pressed key ' + e.keyCode + ' instead of left or right!'

    $scope.NextWord = () ->

      # Set the time on the current word when we move on
      $scope.CurrentWord().stop_time = new Date()

      # Ensure the current word is hidden until next will show up
      # Caution: Needs a timer here otherwise it will not hide the word properly!
      $timeout (-> $scope.show_word = false), 0

      console.log ($scope.CurrentWord().stop_time - $scope.CurrentWord().start_time)

      if $scope.session.word_counter < $scope.number_of_words_per_trial - 1

        # Increase the word counter to get a new current word
        $scope.session.word_counter++

        # Redisplay the new word depending on the timeout set for the word
        $timeout (-> $scope.DisplayWord()), 2000

      else

        # Display the decision matrix
        console.log "Hurray you are done with this trial!"

    $scope.PrepareTest()
  ])
