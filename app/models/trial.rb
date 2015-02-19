class Trial
  include Mongoid::Document

  field :word_delay, type: Integer

  embedded_in :sessions

  embeds_many :words
  embeds_many :retrievals

  accepts_nested_attributes_for :words, :retrievals

  validates :words, :retrievals, :word_delay, presence: true
end
