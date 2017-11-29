class Ipl < ApplicationRecord
  belongs_to :location
  
  validates_presence_of :price, :name
end
