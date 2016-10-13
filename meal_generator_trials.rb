
def self.meal_plan_generator
#create a meal plan for next X days --> create scope above to do this

#don't forget the direction from which you are coming joins must start from the has many side
#e.g. Recipe has_many :meal_plans --> Recipe.joins(:meal_plans)

	@last_week_meals  = MealPlan.where(meal_date: 7.days.ago..1.days.ago)

	@this_week_meals = []
	#hack until I can figure out a better way to do this

	this_week_meal_ids = []
	@random_recipe_list = []
	#make it time out if it tries to many times. Probably base it on the length of recipes table
	count = 0
	while(@this_week_meals.length < 7)
		#is this going to generate a new # every time?
		rando_recipe = Recipe.offset(rand(Recipe.count)).first
		@random_recipe_list.push(rando_recipe)
		if(@this_week_meals.length == 0)
			add_to_recipe_suggestions(@this_week_meals, rando_recipe)
		#elsif(last_week_meal_ids.include?(rando_recipe.id)) 
			#|| @this_week_meals[ct] == rando_recipe)
		count +=1
		elsif(count < 50)
			count +=1
			#add_to_recipe_suggestions
			check_meal_ids(@this_week_meals, rando_recipe)
			#check_grain(@rando_recipe.grain_id) #check to make sure this meal's grain hasn't been used too much
		else
			break
		end
	end

@this_week_meals
@random_recipe_list
end

def self.check_meal_ids(arr, recipe)
	
	arr.each do |a|

		if recipe.name == a.name
			break
		else
			add_to_recipe_suggestions(arr, recipe)
		end
	end

end

#def self.check_grain(id)
#	@grains_for_week = {}
#	@grains_for_week[id]  = (@grains_for_week[id] || 0) + 1
	#if the id value is now greater than say 3, we need to skip this recipe
	#temp hack to see if the basic icea is working
#	val_for_grain_id = @grains_for_week.fetch_values(id)
#	if val_for_grain_id[0] < 3
#		add_to_recipe_suggestions #actually, we'll check the other criteria after this,but test for now
#	end
	#else don't do that!

#end

	#	@proteins_for_week[meal.protein] = (@proteins_for_week[meal.protein] || 0) + 1
		#currently failing because of some null values for difficulty level
		#if(meal.difficulty_level > 3 )
		#	@difficult_items.push(meal.name)
		#end

def self.add_to_recipe_suggestions(arr,item)
	arr.push(item)
end

end
