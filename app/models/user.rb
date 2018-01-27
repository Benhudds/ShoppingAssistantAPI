class User < ApplicationRecord
  
  # encrypt password
  has_secure_password
  has_many :listowners, dependent: :destroy
  has_many :slists, through: :listowners #foreign_key: :created_by
  
  validates_presence_of :name, :email, :password_digest
  validates :email, uniqueness: true
end
