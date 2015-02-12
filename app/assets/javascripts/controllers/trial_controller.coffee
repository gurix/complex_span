@controllers.controller("TrialsController", ['$translate','$scope','localStorageService','$timeout'
  ($translate, $scope, localStorageService, $timeout) ->

    $scope.session = {}
    localStorageService.bind($scope, 'session')
    $scope.show_word = false
    $scope.show_retrieval_matrix = false
    $scope.show_fixation_point = true
    $scope.session.trial_counter = 0
    $scope.clicked_retrieval_counter = 1
    $scope.number_of_trials = 14
    $scope.number_of_words_per_trial = 10
    $scope.number_of_new_words_per_retrieval = 5
    $scope.number_of_selectable_words_per_retrieval = 5

    $scope.ShowFixationPoint = () ->
      $scope.show_fixation_point

    $scope.CurrentTrial = () ->
      $scope.session.trials[$scope.session.trial_counter]

    $scope.CurrentWord = () ->
      $scope.CurrentTrial().words[$scope.session.word_counter]

    $scope.CurrentRetrievals = () ->
      $scope.session.trials[$scope.session.trial_counter].retrievals

    $scope.WordColor = () ->
      'wordcolor' + $scope.CurrentWord().color

    $scope.ShowWord = () ->
      $scope.show_word

    $scope.ShowRetrievalMatrix = () ->
      $scope.show_retrieval_matrix

    $scope.PrepareTest = () ->
      # Let's get a shuffled stack of words
      word_stack = window['words_' + $translate.use()]
      word_stack.shuffle()

      # Generate an array of trials containing the words that we complete later during the test
      $scope.session.trials = []
      word_counter = 0

      for number_of_trials in [1..$scope.number_of_trials]
        words = []
        retrievals = []

        # Shuffle the color for each trial
        word_colors = [1, 1, 1, 1, 1, 2, 2, 2, 2, 2].shuffle()

        # Shuffle the conditions for each trial
        word_delays = [200, 200, 200, 200, 200, 1500, 1500, 1500, 1500, 1500].shuffle()

        for number_of_words in [1..$scope.number_of_words_per_trial]
          word_text = word_stack[word_counter]
          word_color = word_colors[number_of_words - 1]
          delay = word_delays[number_of_words - 1]
          # Add words for each trial
          words.push new window.Word(number_of_trials, number_of_words, word_text, word_color, delay)
          # Push words also to the retrievals
          retrievals.push new window.Retrieval(number_of_trials, number_of_words, word_text, word_color, delay)
          word_counter++

        # Add some additional words in the retrievals not presented before
        for number_of_words_not_presented in [1..$scope.number_of_new_words_per_retrieval]
          word_text = word_stack[word_counter]
          retrievals.push new window.Retrieval(number_of_trials, null, word_text, null, null)
          word_counter++

        # Shuffle the retrievals and update the position
        retrievals.shuffle()
        for number_of_retrievals in [1..retrievals.length]
          retrievals[number_of_retrievals - 1 ].position = number_of_retrievals

        $scope.session.trials.push { words: words, retrievals: retrievals }

      # Start the first trials
      $scope.StartTrial()
      #$scope.DisplayMatrix()

    # (Re)Starts a trial by displaying the first word
    $scope.StartTrial = () ->
      $scope.session.word_counter = 0

      logger.push 'Start with trial ' + $scope.session.trial_counter

      # Show fixation point
      $scope.show_fixation_point = true

      # Start with the first word, delay of 500ms
      $timeout (-> $scope.DisplayWord()), 500

    # Displays the word for presentation
    $scope.DisplayWord = () ->
      logger.push 'Display word ' + $scope.session.word_counter + ' in trial ' + $scope.session.trial_counter

      # Ensure fixation point is hidden
      $scope.show_fixation_point = false

      # Ensure word will be shown
      $scope.show_word = true

      # Remember the time when the current word is displayed
      $scope.CurrentWord().start()

      # Display the word for 2000ms, otherwise it will move to the next word
      next_word = $timeout (-> $scope.NextWord()), 2000

      # Detect keydown event
      # Ensure we unbind the keydown event
      $(document).unbind('keydown')
      $(document).keydown (e) ->

        # It must be left or right
        if (e.keyCode == 39 || e.keyCode == 37)
          logger.push 'Pressed key ' + e.keyCode

          # Record which key was pressed for this word
          $scope.CurrentWord().pressed_key = e.keyCode

          # Ensure no more keydowns are accepted now
          $(document).unbind('keydown')

          # The timeout has to be canceled because we move on to the next word manually
          $timeout.cancel next_word

          # Set the time on the current word when we move on
          $scope.CurrentWord().stop()

          # We emidiatly move on to the next word once left or right was pressed
          if $scope.CurrentWord().reaction_time < 2000
            $scope.NextWord()
          else
            logger.push 'Key pressed after 2000ms! (' + $scope.CurrentWord().reaction_time + 'ms)'
        else
          logger.push 'Pressed key ' + e.keyCode + ' instead of left or right!'

    $scope.NextWord = () ->
      # Ensure the current word is hidden until next will show up
      # Caution: Needs a timer here otherwise it will not hide the word properly!
      $timeout (-> $scope.show_word = false), 0

      if $scope.session.word_counter < $scope.number_of_words_per_trial - 1
        logger.push 'Wait for ' + $scope.CurrentWord().delay + 'ms'
        $timeout (->
          # Increase the word counter to get a new current word
          $scope.session.word_counter++
          # Redisplay the new word depending on the timeout set for the word
          $scope.DisplayWord()
        ), $scope.CurrentWord().delay

      else
        # Display the decision matrix
        $scope.DisplayMatrix()

    # Displays with all words to retrieve after each trial
    $scope.DisplayMatrix = () ->
      $scope.show_retrieval_matrix = true
      $scope.clicked_retrieval_counter = 1

    # Triggers some actions when a user clicked on a word he remembers
    $scope.clickRetrieval = (index) ->
      unless $scope.CurrentRetrievals()[index].clicked
        $scope.CurrentRetrievals()[index].click($scope.clicked_retrieval_counter)
        $scope.clicked_retrieval_counter++

        if $scope.clicked_retrieval_counter > $scope.number_of_selectable_words_per_retrieval
          $scope.show_retrieval_matrix = false
          $scope.session.trial_counter++
          $timeout (-> $scope.StartTrial()), 2000

    # sets class of a clicked retrieval word to .clicked
    $scope.RetrievalClickedClass = (index) ->
      return 'clicked' if $scope.CurrentRetrievals()[index].clicked

    # Prepare test data if no trial started
    $scope.PrepareTest() if $scope.session.trial_counter == 0
  ])
