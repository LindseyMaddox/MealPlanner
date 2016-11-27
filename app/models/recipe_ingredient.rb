class RecipeIngredient < ApplicationRecord
	belongs_to :recipe, inverse_of: :recipe_ingredients
	belongs_to :ingredient, inverse_of: :recipe_ingredients
end
