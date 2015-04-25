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
  field :reaction_time, type: Integer
  field :pressed_key, type: Integer
  field :decision_missing, type: Boolean

  embedded_in :trials

  validates :color, :text, :delay, :size_difference, :trial, :word_position, :word_id, presence: true
end
