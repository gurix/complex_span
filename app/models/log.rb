class Log
  include Mongoid::Document

  field :message, type: String
  field :time, type: DateTime

  embedded_in :sessions

  validates :time, :message, presence: true
end
