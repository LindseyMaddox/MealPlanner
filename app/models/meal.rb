class Meal < ApplicationRecord
	belongs_to :recipe, inverse_of: :meals

	validates :user_id, presence: true

#in controller @time_period = {"last week" => 7, "two weeks ago" => 14}
#For now, let's assume last week is between yesterday and 7 days ago

scope :date_filter, ->(number){
			n = number.to_i
 			start_date = (n + 1).days.ago #since it's beginning and end need to start 1 earlier
 			end_date = (n - 6).days.ago #1 day ago 7-6
 		if number.present? && n >= 7
 	 		where(meal_date: start_date..end_date )
 	 	elsif number.present? && n < 7
 	 		 where(meal_date: start_date..1.days.ago )
 	    else
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


	    scope :current_user_meals, ->(current_user) {where(user_id: current_user.id)}

	    scope :last_week_meals, -> {where(meal_date: 8.days.ago..1.days.ago ).to_a }

	    scope :meal_order, -> {order(:meal_date)}


def self.meal_generator(number)
#don't forget the direction from which you are coming joins must start from the has many side
#e.g. Recipe has_many :meals --> Recipe.joins(:meals)

#create a meal plan for next X days 
	meals_requested = self.number_of_meals(number)

	@last_week_meals = self.last_week_meals

	@this_week_meals = []

	ingredients_hash = {}
	
	#make it time out if it tries to many times. Probably base it on the length of recipes table

	while(@this_week_meals.length < meals_requested)
		
		rando_recipe = self.get_random_recipe
		
		#if they don't have anything on file for last week, go ahead and return false
		if @last_week_meals.empty?
			lw_match = false
		else
			lw_match = self.compare_to_week(@last_week_meals,rando_recipe)
		end


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
	def self.get_random_recipe
		#change id column to recipe_id so it has consistent naming to last week meals
		@random_recipe = Recipe.select("id as recipe_id, recipes.name as name, difficulty_level").offset(rand(Recipe.count)).first
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

	def self.batch_create(post_content)
		meal_values = JSON.parse(post_content)
	  # begin exception handling
	  begin
	    # begin a transaction on the  mp model
	    Meal.transaction do
	      # for each student record in the passed json
	      meal_values.each do |meal_hash|
	        # create a new student
	        Meal.create!(meal_hash)
	      end # json.parse
	    end # transaction
	  rescue
	    # do nothing
	  end  # exception handling
	end  # batch_create

end