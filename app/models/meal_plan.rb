class MealPlan < ApplicationRecord
	belongs_to :recipe

#in controller @time_period = {"last week" => 7, "two weeks ago" => 14}
#For now, let's assume last week is between yesterday and 7 days ago
		scope :date_filter, ->(number){
			start_date = (number.to_i + 1).days.ago #since it's beginning and end need to start 1 earlier
			end_date = (number.to_i - 6).days.ago #1 day ago 7-6
		if number.present?
	 		where(meal_date: start_date..end_date ) 
	    else
	    	#figure out how to reference the other scope below instead of repeating
	    where(meal_date: 8.days.ago..1.days.ago ) 
	    end } 

	    scope :last_week_meals, ->{where(meal_date: 8.days.ago..1.days.ago ).to_a }


def self.meal_plan_generator
#create a meal plan for next X days --> create scope above to do this

#don't forget the direction from which you are coming joins must start from the has many side
#e.g. Recipe has_many :meal_plans --> Recipe.joins(:meal_plans)
	@last_week_meals = self.last_week_meals

	@this_week_meals = []

	grain_counts = {}
	protein_counts = {}
	
	#make it time out if it tries to many times. Probably base it on the length of recipes table

	while(@this_week_meals.length < 7)
		#is this going to generate a new # every time?
		rando_recipe = self.get_random_recipe

		rando_recipe_grain = rando_recipe.grain
		
		match = self.compare_to_last_week(@last_week_meals,rando_recipe)
		
		if(match == false && @this_week_meals.length > 0)
			compare_to_this_week(@this_week_meals, rando_recipe)
			if(match == false)
				add_to_list(@this_week_meals,rando_recipe)
			end
		elsif(match == false ) #if there isn't anything in this week meals, go ahead and add it
			add_to_list(@this_week_meals,rando_recipe)
		else
			next
		end
			#version without sending to another method. yucky so many loops
			#if(grain_counts.has_key?(rando_recipe_grain) && grain_counts.values_at(rando_recipe_grain)[0] < 3)
			#		grain_counts[rando_recipe_grain] = grain_counts[rando_recipe_grain]  + 1
			#		add_to_list(@this_week_meals,rando_recipe)
			#		this_week_meal_ids.push(rando_recipe.id)

			#elsif(grain_counts.has_key?(rando_recipe_grain))
			#	next
			#else
			#	grain_counts[rando_recipe_grain] = 1
			#	add_to_list(@this_week_meals,rando_recipe)
			#	this_week_meal_ids.push(rando_recipe.id)
			#end
			#check_component_part(@this_week_meals,rando_recipe, grain_counts, rando_recipe.grain)
	end

	@this_week_meals

end

def self.get_random_recipe
	@random_recipe = Recipe.offset(rand(Recipe.count)).first
end
#item uses recipe.id
#this week's meal uses recipe.id while last week's has recipe_id
#for now using two methods


def self.compare_to_last_week(arr,item)
	match = true
	item_id_val = item.id
	arr.each do |a|
		a_id_val = a.recipe_id
		if(a_id_val == item_id_val)
			break
		elsif(a_id_val != item_id_val && arr.index(a) == arr.index(arr.last))
			match = false
		else
			next
		end
	end
	match
end

#not eliminating items that are the same
def self.compare_to_this_week(arr,item)
	match = true
	item_id_val = item.id
	arr.each do |a|
		a_id_val = a.id
		if(a_id_val == item_id_val)
			break
		elsif(a_id_val != item_id_val && arr.index(a) == arr.index(arr.last))
			match = false
		else
			next
		end
	end
	match
end

def self.just_to_check_randoms(list)
	list
end

def self.add_to_list(arr, item)
	arr.push(item)
end

#this isn't working now, so will just stuff the main method
def self.check_component_part(arr,recipe, component, type)
	#@this_week_meals = self.meal_plan_generator creates an infinite loop
	#infinite loop if you do if(component[type] == 0)
		if(component.has_key?(type) && component.values_at(type)[0]< 3)
			component[type] = component[type]  + 1
			#for now, but probably would go to check protein next
			add_to_list(arr,recipe)

		#it is in the list but already at 3 items
		elsif(component.has_key?(type))
			#invalid break try to send back to method?
			meal_plan_generator
		#it's not in the list yet, so set it's value to 1
		else
			component[type] = 1
			add_to_list(arr,recipe)
		end
end

end
