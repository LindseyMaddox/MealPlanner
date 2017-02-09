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


	def self.current_user_active_recipes(current_user)
		current_user_recipes(current_user).active_recipes
	end

	protected
	def titleize
		self.name = name.titleize
	end
end
