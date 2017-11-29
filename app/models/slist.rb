class Slist < ApplicationRecord
  has_many :iqps, dependent: :destroy
  
  validates_presence_of :name
end
