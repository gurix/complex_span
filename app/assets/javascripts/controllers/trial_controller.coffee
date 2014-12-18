@controllers.controller("TrialsController", ['$translate','$scope','localStorageService',
  ($translate, $scope, localStorageService) ->

    $scope.session = {}
    localStorageService.bind($scope, 'session')
    $scope.show_word = false
    $scope.session.trial_counter = 0
    $scope.session.word_counter = 0

    $scope.PrepareTest = () ->
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

    $scope.Test = () ->
      console.log $scope.session.trials

    $scope.PrepareTest()

    $scope.Test()
  ])
