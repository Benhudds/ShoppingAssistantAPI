class Slist < ApplicationRecord
  has_many :iqps, dependent: :destroy
  has_many :users, through: :listowners
  has_many :listowners
  
  validates_presence_of :name
end
