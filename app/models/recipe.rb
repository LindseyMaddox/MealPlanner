class Recipe < ApplicationRecord

	#before_validation :capitalize

	validates :name, length: { minimum: 4 }, uniqueness: true
	
	belongs_to :grain

	belongs_to :protein

	has_many :meal_plans

	protected
	#def capitalize
		#temp_arr = name.to_a

		#cap_arr = temp_arr.map do |word|
		#	word.capitalize!
		#end
		#self.name = cap_arr.join
	#end
end
