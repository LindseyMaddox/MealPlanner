class Meal < ApplicationRecord
	# require 'cgi'

	belongs_to :recipe, inverse_of: :meals
	belongs_to :user

	#prevent same meal from being planned more than once on same date
	#recipe_id is already specific to a user so don't need to validate based on that
	validates :recipe_id, uniqueness: {scope: :meal_date,
	 message: "can only occur once per date"}
 
	validates :user_id, presence: true

#in controller @time_period = {"last week" => 7, "two weeks ago" => 14}
#For now, let's assume last week is between yesterday and 7 days ago


	    scope :number_of_meals, ->(number) {
	    	if number.present?
	    		number = number.to_i
	    	else
	    		number = 7
	    	end
	    	number
	    }

	    scope :meal_order, -> { order(:meal_date)}

def self.date_filter(number, current_user)
	n = number.to_i
 	start_date = (n + 1).days.ago #since it's beginning and end need to start 1 earlier
 	end_date = (n - 6).days.ago #1 day ago 7-6

 	if  n >= 7
 	 	self.where(meal_date: start_date..end_date).where(
 	 		'user_id =?', current_user.id)
 	else
 	 	self.where(meal_date: start_date..1.days.ago ).where('user_id = ?', current_user.id)
 	end 
end

def self.last_week_active_meals(current_user)
		@last_week_meals = Recipe.joins(:meals).where("meals.meal_date" => 8.days.ago..1.days.ago ).
	    	where('recipes.user_id = ?', current_user.id).where('recipes.active = ?', true).select("recipes.id as recipe_id").to_a
end

def self.meal_generator(number, current_user)

#don't forget the direction from which you are coming joins must start from the has many side
#e.g. Recipe has_many :meals --> Recipe.joins(:meals)

#create a meal plan for next X days 
	meals_requested = self.number_of_meals(number)

	@last_week_meals = self.last_week_active_meals(current_user)

	@this_week_meals = []

	ingredients_hash = {}
	
	#you can only get the number of active meals - what you had last week that are active
	#if request is >, change meals requested to that number to avoid infinite loop
	#later we may need a more complex solution to account for user specific filtering

	 active_recipe_count = Recipe.current_user_active_recipes(current_user).count
	
	 if meals_requested > active_recipe_count - @last_week_meals.length
	 	meals_requested = active_recipe_count - @last_week_meals.length
	 end

	  while(@this_week_meals.length < meals_requested)

	  	rando_recipe = self.get_random_recipe(current_user)
	  	
	  		#if they don't have anything on file for last week, go ahead and return false
	  	if @last_week_meals.empty?
	  		lw_match = false
	  	else
	  		lw_match = self.compare_to_week(@last_week_meals,rando_recipe)
	  	end
			#we really only want to check each criteria if the criteria before it is met
			#first check for matches with last week and this week
			#then check for ingredient counts
	
	  	if lw_match == true
	  		next
	  	elsif @this_week_meals.empty?
	  		#tw_match = false we can actually add without checking anything else
			#but we also want to move on to the next item
	  		add_to_list(@this_week_meals, rando_recipe)
	  	else
	  		tw_match = self.compare_to_week(@this_week_meals, rando_recipe)
	  	end

	 	#account for nil values with ingredients
	  	if tw_match == false && rando_recipe.ingredients = []

	 		add_to_list(@this_week_meals, rando_recipe)
	  	 elsif tw_match == false 
	  		recipe_max = self.check_amount(@this_week_meals,ingredient_hash, rando_recipe.ingredients)
	  	 else
	  	 	next
	  	 end
	 end
	@this_week_meals	

end
	def self.get_random_recipe(current_user)
		#change id column to recipe_id so it has consistent naming to last week meals
	
		current_user_options = Recipe.select("id as recipe_id, name, difficulty_level").merge(Recipe.current_user_active_recipes(current_user))
	    random_number = rand(current_user_options.length)
		@random_recipe = current_user_options[random_number]
	end

def self.compare_to_week(arr,item)
	match = true
	arr.each do |a|

		if(a.recipe_id == item.recipe_id)
			break
		elsif(a.recipe_id != item.recipe_id && arr.index(a) == arr.index(arr.last))
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



def self.check_amount(arr,hsh, item_list)
	#example method with arguments
	#check_amount(@this_week_meals,recipe_hash, rando_recipe.ingredients)
		
	max = false
	item_list.each do |item|
		if hsh.has_key?(item) && hsh.values_at(item)[0]< 3
			hsh[item] = hsh[item]  + 1
			#max is still false so don't need to add anything
		elsif hsh.has_key?(item) 
			max = true
		else
			#max is still false so don't need to mention. just set the type to 1
			hsh[item] = 1
		end
	end
	max	
end

def self.pantry_meals(ingredients,current_user)
	#need to set up
	query_ingredients = "(" + ingredients.join(',') + ")"
	ingredients_length = ingredients.length
	
 	sql = "Select recipes.*, count(*) as ct from recipes inner join
    recipe_ingredients on recipes.id = recipe_ingredients.recipe_id 
 	where recipe_ingredients.ingredient_id in #{query_ingredients} and recipes.user_id = #{current_user.id}
 	group by recipes.id having ct == #{ingredients_length}" 
 	@pantry_meals =  ActiveRecord::Base.connection.execute(sql)
end

	def self.batch_create(meal_values)
	  # begin exception handling
	  begin
	    # begin a transaction on the  mp model
	    Meal.transaction do
	    	success = false
	      meal_values.each do |meal_hash|
	       	@meal =  Meal.create!(meal_hash)
	      end # json.parse
	    end # transaction
	  rescue
	    Rails.logger.info("Did not create batch records");
	  end  # exception handling
	end  # batch_create

end