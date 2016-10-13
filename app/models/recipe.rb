class Recipe < ApplicationRecord

	
	validates :name, length: { minimum: 4 }
	validates :protein_id, presence: true, allow_nil: true

	belongs_to :grain

	belongs_to :protein

	has_many :meal_plans
end
