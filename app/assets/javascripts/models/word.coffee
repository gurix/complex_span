class window.Word

  # trial_number: Position of the trial
  # word_position: Position of the word within the presentation
  # word: Word object
  # color: The color the word had within the presentation
  # delay: Delay condition the word had within the presentation
  constructor: (@trial_number, @word_position, @word, @color, @delay) ->

  start: () ->
    # start_time: Exact time when the word was shown
    @start_time = new Date()

  stop: () ->
    #stop_time: Exact time when the word was stopped via keystroke
    @stop_time = new Date()
    @reaction_time = @stop_time - @start_time # should not be stored here, application does not aggregate data!
