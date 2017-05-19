class Recipe < ApplicationRecord

	before_validation :titleize


	validates :user_id, presence: true

	validates :name, length: { minimum: 4 }, uniqueness: { scope: :user_id}

	belongs_to :user

	has_many :meals, inverse_of: :recipe

	has_many :recipe_ingredients
	
	has_many :ingredients, through: :recipe_ingredients

	scope :current_user_recipes, ->(current_user) {where('user_id = ?', current_user.id).order(:name)}

	scope :active_recipes, -> {where(active:true)}

	scope :times_eaten, -> (id){ joins(:meals).merge(Meal.meal_order).where('recipes.id =?', id).pluck('meals.meal_date') }

	scope :current_user_difficulty_of_recipes, -> (current_user) { 
		where('user_id = ?', current_user.id).where('active = ?', true).
		group(:difficulty_level).count }


	def self.current_user_active_recipes(current_user)
		current_user_recipes(current_user).active_recipes
	end

	def self.ingredients_in_active_recipes(current_user)
		Recipe.joins(:ingredients).where('user_id = ?', current_user.id).where('active = ?', true).group("ingredients.name").count
	end

	def self.ingredients_in_recent_active_recipe_meals(current_user)
		Recipe.select("ingredients.name").joins(:ingredients).joins(:meals).
		where('meals.meal_date between ? and ?', 31.days.ago, 1.days.ago).
		where(user_id:current_user.id,active:true).group("ingredients.name").count
	end

	def self.difficulty_level_of_recent_meals(current_user)
		Recipe.select("recipes.name").joins(:meals).
		where('meals.meal_date between ? and ?', 31.days.ago, 1.days.ago).
		where('recipes.user_id = ?', current_user.id).group(:difficulty_level).count
    end

    def self.recent_recipe_meals(current_user,isActive)
    	Recipe.select("recipes.name").joins(:meals).
    	where('meals.meal_date between ? and ?', 31.days.ago, 1.days.ago).
    	where('active = ?', isActive).where('recipes.user_id = ?', current_user.id).
    	group("recipes.name").count
    end
    
    def self.pantry_recipes(included,excluded,onlyActive,current_user)
    	
		included_ingredients = "(" + included.join(',') + ")"

		excluded_ingredients = "(" + excluded.join(',') + ")"
#Joining a recipe that has multiple ingredients will return multiple rows,
#so can't query not directly, we need to do a subquery to make sure a recipe with one of those ingredients it not included
		if onlyActive
			@pantry_recipes = Recipe.joins(:recipe_ingredients).where("recipe_ingredients.ingredient_id 
				in #{included_ingredients}").where("recipe_ingredients.recipe_id 
				NOT IN (select recipe_ingredients.recipe_id from recipe_ingredients where recipe_ingredients.ingredient_id in #{excluded_ingredients})").where(active: true).where(user_id: current_user.id).group(:id).having("count(recipes.id) = ?", included.length)
		else
				@pantry_recipes = Recipe.joins(:recipe_ingredients).where("recipe_ingredients.ingredient_id 
				in #{included_ingredients}").where("recipe_ingredients.recipe_id 
				NOT IN (select recipe_ingredients.recipe_id from recipe_ingredients where recipe_ingredients.ingredient_id in #{excluded_ingredients})").where(user_id: current_user.id).group(:id).having("count(recipes.id) = ?", included.length)
		end
	end
	protected
	def titleize
		self.name = name.titleize
	end
end
