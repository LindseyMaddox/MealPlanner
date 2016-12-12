class MealsController < ApplicationController
	before_action :logged_in_user
	
	def index
		number = params[:date_filter] || 7
		@meals = Meal.date_filter(number, current_user)

		#last week, 7 days before date to 14 days before date
		@time_period = {"last week" => 7, "two weeks ago" => 14}
	end

	def planner
		@number_of_meals = {"one meal" => 1, "five meals" => 5, "seven meals" => 7}

		@this_week_meals = Meal.meal_generator(params[:number_of_meals], current_user)
		#@random_recipe = Meal.get_random_recipe(current_user)		
		@grains = Grain.all							   
	end

	def show
		@meal = Meal.find(params[:id])
	end
	
	def new
		@meal = Meal.new

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
  	#binding.pry
    # call the batch create method within the meal plan model
    success = Meal.batch_create(request.raw_post)
    # return an appropriate response
    respond_to do |format|
	    if success
	    	format.html { redirect_to meals_path, notice: 'recommendations were successfully
	            	 added' }
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
end
