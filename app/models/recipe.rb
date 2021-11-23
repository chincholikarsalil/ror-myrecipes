class Recipe < ApplicationRecord
  validates :name, presence: :true, length: {minimum: 5, maximum: 100}
  validates :description, presence: :true, length: {minimum: 10, maximum: 500}
  
  belongs_to :chef
  validates :chef_id, presence: :true
end