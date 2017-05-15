class MealsController < ApplicationController
	before_action :logged_in_user
	before_action :correct_user_meals, only: :show
	def index
		number = params[:date_filter] || 7
		@meals = Meal.date_filter(number,current_user).meal_order

		#last week, 7 days before date to 14 days before date
		@time_period = {"last week" => 7, "two weeks ago" => 14}
	end

	def planner
		@todays_date = Date.today
		@number_of_meals = {"one meal" => 1, "five meals" => 5, "seven meals" => 7}

		@this_week_meals = Meal.meal_generator(params[:number_of_meals],current_user)				   
	end

	def pantry
		@food_groups = FoodGroup.order(:name)
		@ingredients = Ingredient.order(:name)
	end

	def find_meals_with_pantry_ingredients

		ingredients = params[:ingredients].values.map { |item| item[:ingredientID] }
		@pantry_meals = Meal.pantry_meals(ingredients)
	end

	def show
		@meal = Meal.find(params[:id])
	end
	
	def new
		@meal = Meal.new
		@recipes = Recipe.current_user_recipes(current_user)

		respond_to do |format|
	      format.html # new.html.erb
	      format.json { render json: @meal }
	    end
	end

	def create

		 @meal = current_user.meals.build(meal_params)

	    respond_to do |format|
	      if @meal.save
	        format.html { redirect_to @meal, notice: 'meal was successfully created.' }
	        format.json { render json: @meal, status: :created, meal: @meal }
	        format.js
	      else
	        format.html { render action: "new" }
	        format.json { render json: @meal.errors, status: :unprocessable_entity }
	      end
	    end
	end

  def batch_create 
#still not 100% on how to whitelist the params correctly
	 meal_list = []

	# #only send meals to the meal model transaction that are checked
	 params[:meals].each do |meal|
	 	hsh = {}
      	#manually create the hash to be processed by model
  		if meal.has_key?("checked")
  	    	  hsh[:recipe_id] = meal["recipe_id"]
  	    	  hsh[:meal_date] = meal["meal_date"]
  	    	  hsh[:user_id] = meal["user_id"]
  	    	  meal_list.push(hsh)
  		end
	 end
	 success  = Meal.batch_create(meal_list)

	   respond_to do |format|
	    if success
		  format.html { redirect_to meals_path, notice: 'meal plan was successfully created.' }
	      format.json { render json: {success: 'meal plans added'}, status: :created }
	    else
	     format.json { render json: {failed: 'meal plans not added'}, status: :unprocessable_entity }
	    end
	   end
  end

	private

	def meal_params
      params.require(:meal).permit(:recipe_id, :meal_date, :user_id)
    end

   def correct_user_meals
    	id = params[:id]
    	sql = "Select user_id from recipes where user_id = id"
    	@user_id = Meal.select(:user_id).find(params[:id])
    	evaluate_auth_and_redirect(@user_id)
  end

end
