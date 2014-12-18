@controllers.controller("TrialsController", ['$translate','$scope','localStorageService',
  ($translate, $scope, localStorageService) ->
    $scope.trial_counter = 1
    $scope.word_counter = 1

    $scope.session = {}
    localStorageService.bind($scope, 'session')

    $scope.PrepareTest = () ->
      # Let's get a shuffled stack of words
      word_stack = window['words_' + $translate.use()]
      word_stack.shuffle()

      # We have two collors
      word_colors = [1, 1, 1, 1, 1, 2, 2, 2, 2, 2]

      # Generate an array of words objects that we fill later during the test
      $scope.session.words = []
      i = 0
      for number_of_trials in [1..14]
        word_colors.shuffle() # Shuffle word colors for each trial
        for number_of_words in [1..10]
          $scope.session.words.push new window.Word(number_of_trials, number_of_words, word_stack[i], word_colors[number_of_words - 1])
          i++
      console.log $scope.session.words
    $scope.PrepareTest()
  ])
