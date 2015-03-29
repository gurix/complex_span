@controllers.controller("TrialsController", ['$translate','$scope','localStorageService','$timeout'
  ($translate, $scope, localStorageService, $timeout) ->

    localStorageService.bind($scope, 'session')
    $scope.show_word = false
    $scope.show_retrieval_matrix = false
    $scope.show_fixation_point = false

    $scope.session.word_counter = 0
    $scope.clicked_retrieval_counter = 1
    $scope.number_of_trials_to_practice = 2
    $scope.number_of_selectable_words_per_retrieval = 5
    $scope.show_instruction = false
    $scope.show_instruction_1_2 = false
    $scope.show_blue_circle = false
    $scope.show_retrieval_matrix_instruction_red = false
    $scope.show_retrieval_matrix_instruction_blue = false

    $scope.ShowFixationPoint = () ->
      $scope.show_fixation_point

    $scope.CurrentTrial = () ->
      $scope.session.trials[$scope.session.trial_counter]

    $scope.CurrentWord = () ->
      $scope.CurrentTrial().words[$scope.session.word_counter]

    $scope.CurrentRetrievals = () ->
      $scope.CurrentTrial().retrievals

    $scope.WordColor = () ->
      $scope.CurrentWord().color + '_word'

    $scope.ColorOfRetrievalMatrixInstruction = () ->
      if $scope.session.trial_counter == 13 then 'blue' else 'red'

    $scope.ShowWord = () ->
      $scope.show_word

    $scope.ShowRetrievalMatrix = () ->
      $scope.show_retrieval_matrix

    $scope.ShowInstruction = () ->
      $scope.show_instruction

    $scope.ShowInstruction_1_2 = () ->
      $scope.show_instruction_1_2

    $scope.ShowRetrievalMatrixInstructionRed = () ->
      $scope.show_retrieval_matrix_instruction_red

    $scope.ShowRetrievalMatrixInstructionBlue = () ->
      $scope.show_retrieval_matrix_instruction_blue

    $scope.ShowBlueCircle = () ->
       $scope.show_blue_circle

    # (Re)Starts a trial by displaying the first word
    $scope.StartTrial = () ->
      # Ensure the cursor is hidden in this view
      $('body').addClass('no-cursor')

      # Reset word counter
      $scope.session.word_counter = 0

      # Register the time when a trial is started
      $scope.CurrentTrial().started_at = new Date()

      logger.push "Start with trial #{$scope.session.trial_counter}"

      # Show fixation point
      $scope.show_fixation_point = true

      # Start with the first word, delay of 500ms
      $timeout (-> $scope.DisplayWord()), 500

    # Displays the word for presentation
    $scope.DisplayWord = () ->
      logger.push "Display word #{$scope.session.word_counter} in trial #{$scope.session.trial_counter} with color #{$scope.CurrentWord().color} and text #{$scope.CurrentWord().text}"

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

          # Record which key was pressed for this word
          $scope.CurrentWord().pressed_key = e.keyCode

          # Ensure no more keydowns are accepted now
          $(document).unbind('keydown')

          # The timeout has to be canceled because we move on to the next word manually
          $timeout.cancel next_word

          # Set the time on the current word when we move on
          $scope.CurrentWord().stop_time = new Date()
          $scope.CurrentWord().reaction_time = $scope.CurrentWord().stop_time - $scope.CurrentWord().start_time

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

      if $scope.session.word_counter < 9
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

      # Enable the cursor, we need it to select the word
      $('body').removeClass('no-cursor')

      logger.push 'Start with retrieval of session ' + $scope.session.trial_counter
      $scope.show_retrieval_matrix = true
      $scope.clicked_retrieval_counter = 0

      if $scope.session.trial_counter == 13
        $scope.show_blue_circle = true
        $scope.show_blue_circle_instruction = true
        $scope.show_retrieval_matrix_instruction_blue = true
        $scope.show_retrieval_matrix_instruction_red = false
      else
        $scope.show_retrieval_matrix_instruction_red = true
        $scope.CurrentTrial().retrieval_matrix_shown_at = new Date()

    # Triggers some actions when a user clicked on a word he remembers
    $scope.ClickRetrieval = (index) ->
      retrieval_id = '#retrieval-' + index

      clicked_retrieval = JSON.parse(JSON.stringify $scope.CurrentRetrievals()[index])

      $scope.clicked_retrieval_counter++

      logger.push "Clicked #{$scope.clicked_retrieval_counter} on word #{$scope.CurrentRetrievals()[index].text} with color #{$scope.CurrentRetrievals()[index].color}"

      # Save properties of the click
      clicked_retrieval.clicked_at = new Date()
      clicked_retrieval.click_order = $scope.clicked_retrieval_counter

      $scope.CurrentTrial().retrieval_clicks.push clicked_retrieval

      $(retrieval_id).addClass 'clicked'

      $timeout (-> $(retrieval_id).removeClass 'clicked'), 300

      if $scope.clicked_retrieval_counter >= $scope.number_of_selectable_words_per_retrieval
        # Hide the cursor immediately
        $('body').addClass('no-cursor')

        # Hide Matrix
        $timeout (->
          $scope.show_retrieval_matrix = false

          if $scope.session.trial_counter < 13
            $scope.session.trial_counter++

            if $scope.session.trial_counter == $scope.number_of_trials_to_practice
              # Redisplay instruction before the real test starts
              $timeout (-> $scope.DisplayInstruction_1_2()), 1300
            else
              $timeout (-> $scope.StartTrial()), 2000
          else
            $timeout (-> location.href = '#/finishing'), 1000
        ), 1000


    $scope.DisplayInstruction_1_2 = () ->
      $timeout (-> $scope.show_instruction_1_2 = true), 0
      logger.push 'Show instruction 1_2'

      $(document).unbind('keydown')
      $(document).keydown (e) ->
        # Left arrow pressed redisplay the instruction
        if e.keyCode is 37
          $timeout (-> $scope.show_instruction_1_2 = false), 0
          $scope.DisplayInstruction()
        # Right arrow pressed preceed with the real test
        if e.keyCode is 39
          $timeout (-> $scope.show_instruction_1_2 = false), 0
          $timeout (-> $scope.StartTrial()), 2000
        e.preventDefault()

    #
    $scope.DisplayInstruction = () ->
      $timeout (-> $scope.show_instruction = true), 0
      logger.push 'Show instruction'

      $(document).unbind('keydown')
      $(document).keydown (e) ->
        # Left arrow pressed, redisplay the insturction 1.2
        if e.keyCode is 39
          $timeout (-> $scope.show_instruction = false), 0
          $scope.DisplayInstruction_1_2()
        e.preventDefault()

    $scope.ClickBlueCircle = () ->
      $scope.CurrentTrial().retrieval_matrix_shown_at = new Date()
      $timeout (-> $scope.show_blue_circle = false), 0

    # Start the first trials
    $scope.StartTrial()
  ])
