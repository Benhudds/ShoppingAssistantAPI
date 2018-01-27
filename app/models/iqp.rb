class Iqp < ApplicationRecord
  belongs_to :slist
  
  validates_presence_of :item, :quantity, :measure
end
