class MealPlan < ApplicationRecord
	belongs_to :recipe, inverse_of: :meal_plans
#if they don't have anything input to the database for that period, we need to perform a different 
#set of methods

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

	    scope :number_of_meals, ->(number) {
	    	if number.present?
	    		number = number.to_i
	    	else
	    		number = 7
	    	end
	    	number
	    }

	    scope :last_week_meals, ->{where(meal_date: 8.days.ago..1.days.ago ).to_a }

def self.set_date_options
	current_date = Date.today.strftime("%m/%d/%Y")
	@date_options = []
	@date_options.push(current_date)

	(1..7).each do |x|
		date = x.days.from_now.strftime("%m/%d/%Y")
		@date_options.push(date)
	end
	@date_options
end

def self.meal_plan_generator

#don't forget the direction from which you are coming joins must start from the has many side
#e.g. Recipe has_many :meal_plans --> Recipe.joins(:meal_plans)

	@last_week_meals = self.last_week_meals

	@this_week_meals = []

	while @this_week_meals.length < 1
	#random recipe is pulling from the recipe table, so recipe id is just ID
		rando_recipe = self.get_random_recipe
		
		#this is dumb. should set up differently
		lw_string = "lw"
		tw_string = "tw"

		#if they don't have anything on file for last week, go ahead and return false
		if @last_week_meals.empty?
			lw_match = false
		else
			lw_match = self.compare_to_week(@last_week_meals,rando_recipe,lw_string)
		end

		# we really only want to check each criteria if the criteria before it is met
		#first check for matches with last week and this week
		#then check for grain and protein counts
		
		if lw_match == true
			next
		else
			add_to_list(@this_week_meals, rando_recipe)
		end

		#could add code here to specify difficulty level, grain type, etc.
	end
	@this_week_meals	
end

def self.get_random_recipe
	@random_recipe = Recipe.offset(rand(Recipe.count)).first
end
#item uses recipe.id
#this week's meal uses recipe.id while last week's has recipe_id
#for now using two methods


def self.compare_to_week(arr,item,week)
	match = true
	item_id_val = item.id
	arr.each do |a|

		#the recipe id is in a different location if it's already in meal plans
		#we may want to go back and map the ids or something (in the original or another earlier method) so that it is the same for both
		if(week == "tw")
			a_id_val = a.id
		else
			a_id_val = a.recipe_id
		end

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

def self.add_to_list(arr, item)
	arr.push(item)
end

#this isn't working now, so will just stuff the main method
def self.check_component_part(arr,component_hash, type)
	#example method with arguments
	#check_component_part(@this_week_meals,rando_recipe,grain_counts,rando_recipe.grain.name)
		
	max = false
		if component_hash.has_key?(type) && component_hash.values_at(type)[0]< 3
			component_hash[type] = component_hash[type]  + 1
			#grain_max is still false so don't need to add anything
		elsif component_hash.has_key?(type) 
			max = true
		else
			#grain_max is still false so don't need to mention. just set the type to 1
			component_hash[type] = 1
		end

	max	
end

end
