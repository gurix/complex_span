class Retrieval
  include Mongoid::Document

  field :color, type: String
  field :text, type: String
  field :delay, type: Integer
  field :size_difference, type: Integer
  field :trial, type: Integer
  field :word_position, type: Integer
  field :word_id, type: Integer
  field :retrieval_position, type: Integer

  field :clicked, type: Boolean
  field :clicked_at, type: DateTime
  field :click_order, type: Integer

  embedded_in :trials
  # validates :color, :text, :delay, :size_difference, :trial, :word_position, :word_id, :clicked, :retrieval_position, :clicked_at, :click_order, presence: true
end
