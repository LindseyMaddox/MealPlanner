class Recipe < ApplicationRecord

	before_validation :titleize


	validates :user_id, presence: true

	validates :name, length: { minimum: 4 }, uniqueness: { scope: :user_id}

	belongs_to :grain, optional: true

	belongs_to :user

	has_many :meals, inverse_of: :recipe

	has_many :recipe_ingredients
	
	has_many :ingredients, through: :recipe_ingredients

	default_scope -> { order(:name) }


	scope :current_user_recipes, ->(current_user) {where('user_id = ?', current_user.id)}

	scope :times_eaten, -> (id){ joins(:meals).merge(Meal.meal_order).where('recipes.id =?', id).pluck('meals.meal_date') }

	scope :grain_requests, ->(grain_id) { 
    	if grain_id.present?
      		Recipe.where('grain_id = ?', grain_id ) 
      	else
      		Recipe.all
    	end 
    }
    #need to abstract
	protected
	def titleize
		self.name = name.titleize
	end
end
