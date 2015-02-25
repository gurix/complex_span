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

  embedded_in :trials
  validates :text, :size_difference, :trial, :word_id, :retrieval_position, presence: true
end
