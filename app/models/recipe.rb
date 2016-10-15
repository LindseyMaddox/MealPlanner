class Recipe < ApplicationRecord

	before_validation :titleize

	validates :name, length: { minimum: 4 }, uniqueness: true
	
	belongs_to :grain

	belongs_to :protein

	has_many :meal_plans

	protected
	def titleize
		self.name = name.titleize
	end
end
