class Session
  include Mongoid::Document
  include Mongoid::Timestamps

  field :age,                type: Integer
  field :sincerity,          type: String
  field :gender,             type: String
  field :education,          type: String
  field :system_information, type: Hash
  field :ip_address,         type: String
  field :language,           type: String
  field :mturkid,            type: String

  embeds_many :logs
  embeds_many :trials

  accepts_nested_attributes_for :logs, :trials

  validates :system_information, :logs, :ip_address, :language,  presence: true
end
