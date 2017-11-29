class Item < ApplicationRecord
  # Associates item with itempricelocation objects
  has_many :ipls, dependent: :destroy
  has_many :locations, through: :ipls
  
  validates_presence_of :name
end
