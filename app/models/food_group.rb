class FoodGroup < ApplicationRecord
	has_many :ingredients

	def self.recent_food_groups_in_meals(current_user)
	    @food_group_data = FoodGroup.select("food_groups.name").
	    joins(ingredients: [{recipes: :meals}]).
	    where('meals.meal_date between ? and ?', 31.days.ago, 1.days.ago).
    	where('recipes.user_id = ?', current_user.id).group("food_groups.name").count
    end
end
