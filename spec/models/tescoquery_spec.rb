require 'rails_helper'

RSpec.describe Tescoquery, type: :model do
  it { should validate_presence_of(:query) }
end
