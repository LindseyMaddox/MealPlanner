class Recipe < ApplicationRecord

	before_validation :titleize

	validates :name, length: { minimum: 4 }, uniqueness: true
	
	belongs_to :grain

	belongs_to :protein

	has_many :meal_plans, inverse_of: :recipe

	accepts_nested_attributes_for :meal_plans, reject_if: lambda {|attributes| attributes['meal_date'].blank?}

	
	protected
	def titleize
		self.name = name.titleize
	end
end
