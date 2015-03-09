class Trial
  include Mongoid::Document

  field :word_delay, type: Integer
  field :retrieval_matrix_shown_at, type: DateTime
  field :started_at, type: DateTime

  embedded_in :sessions

  embeds_many :words
  embeds_many :retrievals
  embeds_many :retrieval_clicks

  accepts_nested_attributes_for :words, :retrievals, :retrieval_clicks

  validates :words, :retrievals, :retrieval_clicks, :word_delay, :retrieval_matrix_shown_at, :started_at, presence: true
end
