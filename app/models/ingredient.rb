class Ingredient < ApplicationRecord
	before_validation :titleize

	has_many :recipe_ingredients
	
	has_many :recipes, through: :recipe_ingredients

	belongs_to :food_group

	validates :name, uniqueness: { case_sensitive: false }

	scope :pantry_selected_ingredients, ->(ingredients) {where('id in (?)', ingredients).order(:name)}


	protected
	def titleize
		self.name = name.titleize
	end
end
