class Recipe < ApplicationRecord

	before_validation :titleize

	validates :name, length: { minimum: 4 }, uniqueness: true
	
	belongs_to :grain

	belongs_to :protein

	has_many :meal_plans, inverse_of: :recipe

	default_scope -> { order(:name) }

	scope :times_eaten, -> (id){ joins(:meal_plans).merge(MealPlan.meal_order).where(id: id).pluck('meal_plans.meal_date') }

	protected
	def titleize
		self.name = name.titleize
	end
end
