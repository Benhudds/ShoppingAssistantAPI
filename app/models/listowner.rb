class Listowner < ApplicationRecord
  belongs_to :slist
  belongs_to :user
end
