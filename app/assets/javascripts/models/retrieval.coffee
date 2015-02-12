class window.Retrieval

  # position: Position within the retrieval
  @position = 0

  # click_order: Order where the retrieval was clicked
  @click_order = null

  # clicked: indicates whether the retrieval was clicked or not
  @clicked = false

  # trial_number: Position of the trial
  # word_position: Position of the word within the presentation
  # word: Word object
  # color: The color the word had within the presentation
  # delay: Delay condition the word had within the presentation
  constructor: (@trial_number, @word_position, @word, @color, @delay) ->

  click: (order) ->
    # clicked_at: Exact time when the retrieval was clicked
    @clicked_at = new Date()
    @clicked = true
    @click_order = order
