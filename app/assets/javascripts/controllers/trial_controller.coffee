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
    $scope.last_click = new Date()
    $scope.show_retrieval_matrix_instruction_red = false
    $scope.show_retrieval_matrix_instruction_blue = false
    $scope.show_decision_warning = false
    $scope.show_to_many_wrong_decisions_warning = false
    
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
    
    $scope.ShowDecisionWarning = () ->
       $scope.show_decision_warning
       
    $scope.ShowToManyWrongDecisionsWarning = () ->
      $scope.show_to_many_wrong_decisions_warning

    # (Re)Starts a trial by displaying the first word
    $scope.StartTrial = () ->
      $scope.session.started = true
      $scope.CurrentTrial().correct_judgments = 0
      $scope.CurrentTrial().retrieval_clicks = []
      $scope.repeat_trial = false
      
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

      # Display the word for 2500ms, otherwise it will move to the next word
      next_word = $timeout (-> $scope.NextWord()), 2500

      # Detect keydown event
      # Ensure we unbind the keydown event
      $(document).unbind('keydown')
      $(document).keydown (e) ->

        keydown_time = new Date()
        reaction_time = keydown_time - $scope.CurrentWord().start_time

        if (reaction_time > 200)
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
            $scope.CurrentWord().stop_time = keydown_time
            $scope.CurrentWord().reaction_time = reaction_time
            
            # Determine whether the word was judged correctly
            if $scope.CurrentWord().size_difference > 0
              $scope.CurrentWord().judgment_correct = $scope.CurrentWord().pressed_key == 39
            else
              $scope.CurrentWord().judgment_correct = $scope.CurrentWord().pressed_key == 37
            
            $scope.CurrentTrial().correct_judgments++ if $scope.CurrentWord().judgment_correct
            
            # We immediately move on to the next word once left or right was pressed
            if $scope.CurrentWord().reaction_time < 2500 
              $scope.NextWord()
            else
              logger.push 'Key pressed after 2500ms! (' + $scope.CurrentWord().reaction_time + 'ms)'
          else
            logger.push 'Pressed key ' + e.keyCode + ' instead of left or right!'
        else
          logger.push 'Reaction time ' + reaction_time + 'ms to fast'

    $scope.NextWord = () ->
      # Ensure the current word is hidden until next will show up
      # Caution: Needs a timer here otherwise it will not hide the word properly!
      $timeout (-> $scope.show_word = false), 0
      wait_for_next_word = 0
      
      $scope.CurrentWord().decision_missing = (typeof $scope.CurrentWord().reaction_time == 'undefined')
      if $scope.CurrentWord().decision_missing && $scope.session.trial_counter < 2
        logger.push "Decision for #{$scope.CurrentWord().position} in trial #{$scope.session.trial_counter} missing" if $scope.CurrentWord().decision_missing
        $scope.show_decision_warning = true
        wait_for_next_word = 2000
      
      $timeout (->   
        
        $scope.show_decision_warning = false
        
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
      ), wait_for_next_word
      
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
      time_between_clicks = (new Date()) - $scope.last_click
      
      if time_between_clicks > 300
        $scope.last_click = new Date()
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
          $scope.NextTrial()
      else
        logger.push 'Clicked within ' + time_between_clicks + 'ms to fast'

    $scope.NextTrial = () ->
      # Hide the cursor immediately
      $('body').addClass('no-cursor')
      # Hide Matrix imediately
      $scope.show_retrieval_matrix = false
    
      wait_for_next_trial = 1000
      not_enough_correct = $scope.CurrentTrial().correct_judgments < 5 
      within_serious_testing = $scope.session.trial_counter > 1 && $scope.session.trial_counter < 13
      
      # While testing repeat trials having not correct judgments
      if not_enough_correct && within_serious_testing
        logger.push "#{$scope.CurrentTrial().correct_judgments} correct judgments, repeating trial #{$scope.session.trial_counter}"
        $scope.CurrentTrial().repeated = true
        $scope.show_to_many_wrong_decisions_warning = true
        $timeout (-> 
          $scope.show_to_many_wrong_decisions_warning = false
          $timeout (-> $scope.StartTrial()), 2000
        ), 2000
      else
        if $scope.session.trial_counter < 13
          $scope.session.trial_counter++ 

          if $scope.session.trial_counter == $scope.number_of_trials_to_practice
            # Redisplay instruction before the real test starts
            $timeout (-> $scope.DisplayInstruction_1_2()), 1300
          else
            $timeout (-> $scope.StartTrial()), 2000
        else
          $timeout (-> location.href = '#/finishing'), 1000

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

    if $scope.session.started == true
      localStorage.clear()
      location.href='#/session/test_already_started'

    else
      $scope.StartTrial()
  ])
