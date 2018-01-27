class Ipl < ApplicationRecord
  belongs_to :location
  
  validates_presence_of :price, :item, :quantity, :measure
end
