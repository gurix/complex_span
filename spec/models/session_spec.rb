require 'rails_helper'

describe Session do
  it { expect(subject).to validate_presence_of(:system_information) }
  it { expect(subject).to validate_presence_of(:logs) }
  it { expect(subject).to validate_presence_of(:ip_address) }
  it { expect(subject).to validate_presence_of(:language) }
end
