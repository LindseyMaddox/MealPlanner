class Ingredient < ApplicationRecord
	before_validation :titleize

	has_many :recipe_ingredients
	has_many :recipes, through: :recipe_ingredients

	default_scope -> { order(:name) }
	
	protected
	def titleize
		self.name = name.titleize
	end
	
end
