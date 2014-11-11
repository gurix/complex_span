class Session
  include Mongoid::Document

  field :age, type: Integer
  field :sincerity, type: Boolean
  field :gender
  field :educational_achievement
  field :system_information, type: Hash

  validates :age, :gender, :educational_achievement, :system_information, :sincerity, presence: true 
end
