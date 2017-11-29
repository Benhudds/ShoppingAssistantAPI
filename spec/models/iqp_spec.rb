require 'rails_helper'

RSpec.describe Iqp, type: :model do
  it { should belong_to(:slist) }
  
  it {should validate_presence_of(:item) }
  it {should validate_presence_of(:quantity) }
end
