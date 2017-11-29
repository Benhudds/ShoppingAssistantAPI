require 'rails_helper'

RSpec.describe Ipl, type: :model do
  it { should belong_to(:location) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:name) }
end
