class Recipe < ApplicationRecord

	before_validation :titleize


	validates :user_id, presence: true

	validates :name, length: { minimum: 4 }, uniqueness: { scope: :user_id}

	belongs_to :user

	has_many :meals, inverse_of: :recipe

	has_many :recipe_ingredients
	
	has_many :ingredients, through: :recipe_ingredients

	scope :current_user_recipes, ->(current_user) {where('user_id = ?', current_user.id).order(:name)}

	scope :times_eaten, -> (id){ joins(:meals).merge(Meal.meal_order).where('recipes.id =?', id).pluck('meals.meal_date') }

	protected
	def titleize
		self.name = name.titleize
	end
end
