class window.Word

  constructor: (@trial_number, @word_position, @word, @word_color) ->
    @is_tutorial = @trial_number < 3 # Mark word as practice for the first two trial numbers

  start: () ->
    @start_time = new Date()

  stop: () ->
    @stop_time = new Date()
    @reaction_time = @stop_time - @start_time # should not be stored application does not aggregate data!
