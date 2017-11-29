require 'rails_helper'

RSpec.describe Slist, type: :model do
  it { should have_many(:iqps).dependent(:destroy) }
  
  it { should validate_presence_of(:name) }
end
