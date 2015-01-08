@controllers.controller("TrialsController", ['$translate','$scope','localStorageService','$timeout'
  ($translate, $scope, localStorageService, $timeout) ->

    $scope.session = {}
    localStorageService.bind($scope, 'session')
    $scope.show_word = false
    $scope.show_fixation_point = true
    $scope.session.trial_counter = 0
    $scope.session.word_counter = 0

    $scope.ShowFixationPoint = () ->
      $scope.show_fixation_point

    $scope.CurrentWord = () ->
      $scope.session.trials[$scope.session.trial_counter].words[$scope.session.word_counter].word

    $scope.ShowWord = () ->
      $scope.show_word

    $scope.PrepareTest = () ->
      # Show fixation point
      $scope.show_fixation_point = true

      # Let's get a shuffled stack of words
      word_stack = window['words_' + $translate.use()]
      word_stack.shuffle()

      # We have two collors
      word_colors = [1, 1, 1, 1, 1, 2, 2, 2, 2, 2]

      # Generate an array of trials containing the words that we complete later during the test
      $scope.session.trials = []
      i = 0
      for number_of_trials in [1..14]
        word_colors.shuffle() # Shuffle word colors for each trial
        words = []
        for number_of_words in [1..10]
          words.push new window.Word(number_of_trials, number_of_words, word_stack[i], word_colors[number_of_words - 1])
          i++
        $scope.session.trials.push { words: words, selections: [] } # implement selections later here

      # Start the first trials
      $scope.StartTrial()


    $scope.StartTrial = () ->
      $timeout (-> $scope.DisplayWord()), 500

    $scope.DisplayWord = () ->
      $scope.show_fixation_point = false
      $scope.show_word = true
      $scope.CurrentWord().start_time = new Date()

      next_word = $timeout (-> $scope.NextWord()), 2000

      $(document).keydown (e) ->
        if e.keyCode == 39 || e.keyCode == 37
          console.log 'stop'
          $timeout.cancel next_word
          $scope.NextWord()
          $(document).unbind('keydown')

    $scope.NextWord = () ->
      $scope.CurrentWord().stop_time = new Date()
      $scope.show_word = false

      console.log ($scope.CurrentWord().stop_time - $scope.CurrentWord().start_time)
      $scope.session.word_counter++

      $timeout (-> $scope.DisplayWord()), 500

    $scope.PrepareTest()
  ])
