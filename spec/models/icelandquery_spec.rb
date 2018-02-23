require 'rails_helper'

RSpec.describe Icelandquery, type: :model do
  it { should validate_presence_of(:query) }
end
