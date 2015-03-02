class Session
  include Mongoid::Document

  field :age, type: Integer
  field :sincerity, type: String
  field :gender
  field :education
  field :system_information, type: Hash
  field :trials, type: Array
  field :ip_address, type: String

  embeds_many :logs
  embeds_many :trials

  accepts_nested_attributes_for :logs, :trials

  validates :age, :gender, :education, :system_information, :sincerity, :logs, :trials, :ip_address, presence: true
end
