class Word
  include Mongoid::Document

  field :color, type: String
  field :text, type: String
  field :delay, type: Integer
  field :size_difference, type: Integer
  field :trial, type: Integer
  field :word_position, type: Integer
  field :word_id, type: Integer

  field :start_time, type: DateTime
  field :stop_time, type: DateTime
  field :reaction_time, type: Integer # Should not taken from here!
  field :pressed_key, type: Integer

  embedded_in :trials

  # validates :color, :text, :delay, :size_difference, :trial, :word_position, :word_id, :start_time, :stop_time, :reaction_time, :pressed_key, presence: true
end
