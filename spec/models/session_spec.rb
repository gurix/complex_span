require 'rails_helper'

describe Session do
  it { expect(subject).to validate_presence_of(:system_information) }
  it { expect(subject).to validate_presence_of(:sincerity) }
  it { expect(subject).to validate_presence_of(:age) }
  it { expect(subject).to validate_presence_of(:gender) }
  it { expect(subject).to validate_presence_of(:education) }
end
