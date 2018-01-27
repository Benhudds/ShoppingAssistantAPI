require 'rails_helper'

RSpec.describe Locationquery, type: :model do
  it { should validate_presence_of(:lat) }
  it { should validate_presence_of(:lng) }
end
