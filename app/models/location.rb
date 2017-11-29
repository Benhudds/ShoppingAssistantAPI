class Location < ApplicationRecord
  # Associates location with itempricelocation objects
  has_many :ipls, dependent: :destroy
  
  validates_presence_of :name, :lat, :lng, :vicinity, :googleid
end
