require 'rails_helper'

RSpec.describe Listowner, type: :model do
  it { should belong_to(:slist) }
  it { should belong_to(:user) }
end
