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

	    scope :number_of_meals, ->(number) {
	    	if number.present?
	    		number = number.to_i
	    	else
	    		number = 7
	    	end
	    	number
	    }

	    scope :last_week_meals, ->{where(meal_date: 8.days.ago..1.days.ago ).to_a }

def self.meal_plan_generator(number)

#don't forget the direction from which you are coming joins must start from the has many side
#e.g. Recipe has_many :meal_plans --> Recipe.joins(:meal_plans)

#create a meal plan for next X days 
	meals_requested = self.number_of_meals(number)

	@last_week_meals = self.last_week_meals

	@this_week_meals = []

	grain_counts = {}
	protein_counts = {}
	
	#make it time out if it tries to many times. Probably base it on the length of recipes table

	while(@this_week_meals.length < meals_requested)
		
		#random recipe is pulling from the recipe table, so recipe id is just ID
		rando_recipe = self.get_random_recipe
		
		#this is dumb. should set up differently
		lw_string = "lw"
		tw_string = "tw"

		lw_match = self.compare_to_week(@last_week_meals,rando_recipe,lw_string)
		

		# we really only want to check each criteria if the criteria before it is met
		#first check for matches with last week and this week
		#then check for grain and protein counts
		
		if lw_match == true
			next
		elsif @this_week_meals.empty?
			#tw_match = false we can actually add without checking anything else
			#but we also want to move on to the next item
			add_to_list(@this_week_meals, rando_recipe)
		else
			tw_match = self.compare_to_week(@this_week_meals, rando_recipe,tw_string)
		end

		if(tw_match == false)
			grain_max = self.check_component_part(@this_week_meals,grain_counts,rando_recipe.grain.name)
		else
			next
		end

		if(grain_max == false)
			protein_max = self.check_component_part(@this_week_meals,protein_counts,rando_recipe.protein.name)
		else
			next
		end

		if(protein_max == false)
			add_to_list(@this_week_meals,rando_recipe)
		else
			next
		end

	end

	@this_week_meals	
end

#for js code only
def self.meal_plan_generator_ids(number)
	@this_week_meals = self.meal_plan_generator(number)

	@this_week_meal_ids = []

	@this_week_meals.each do |meal|
		@this_week_meal_ids.push(meal.id)
	end

	@this_week_meal_ids
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
#NOT CURRENTLY USING
	#def self.batch_create(post_content)
		#begin exception handling
			#begin
				# begin a transaction on the mp model
    			#MealPlan.transaction do
      			# for each record
      				#inputs.each do |input|
        				# create a new meal plan
        			#	MealPlan.create!(input)
      				#end 
    			#end # transaction
  			#rescue
    			# do nothing
    			#Rails.logger.info("Did not create batch records")
  			#end  # exception handling
	#end  # batch_create

end
