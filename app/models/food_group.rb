class FoodGroup < ApplicationRecord
	has_many :ingredients

	def self.recent_food_groups_in_meals(current_user)

    	sql = "Select fg2.name as food_group_name, count(sub.fg_id) from (select fg1.id as fg_id from food_groups fg1 inner join ingredients on ingredients.food_group_id = fg_id
inner join recipe_ingredients on recipe_ingredients.ingredient_id = ingredients.id
inner join recipes on recipes.id = recipe_ingredients.recipe_id
inner join meals on meals.recipe_id = recipes.id
where meals.user_id = #{current_user.id} and meals.meal_date between datetime('now', '-31 days') AND datetime('now', '-1 days')
group by fg1.id, recipes.id) sub 
inner join food_groups fg2 on fg2.id = sub.fg_id
group by sub.fg_id
"
	data = ActiveRecord::Base.connection.execute(sql)
	@food_group_data = {}
	data.each do |item|
		@food_group_data[item["food_group_name"]] = item["count(sub.fg_id)"]
	end
	@food_group_data
    end
end
