class MealPlansController < ApplicationController
	def index

		@meal_plans = MealPlan.meal_order.date_filter(params[:date_filter])
		#last week, 7 days before date to 14 days before date
		@time_period = {"last week" => 7, "two weeks ago" => 14}
	end

	def planner
		@number_of_meals = {"one meal" => 1, "five meals" => 5, "seven meals" => 7}
		@this_week_meals = MealPlan.meal_plan_generator(params[:number_of_meals])		
		@grains = Grain.all							   
	end

	def show
		@meal_plan = MealPlan.find(params[:id])
	end
	
	def new
		@meal_plan = MealPlan.new

		respond_to do |format|
	      format.html # new.html.erb
	      format.json { render json: @meal_plan }
	    end
	end

	def create
		
		 @meal_plan = MealPlan.new(meal_plan_params)

		 #still need to figure out where to redirect when posting from ajax
	    
	    respond_to do |format|
	      if @meal_plan.save
	        format.html { redirect_to @meal_plan, notice: 'meal_plan was successfully created.' }
	        format.json { render json: @meal_plan, status: :created, meal_plan: @meal_plan }
	        format.js
	      else
	        format.html { render action: "new" }
	        format.json { render json: @meal_plan.errors, status: :unprocessable_entity }
	      end
	    end
	end

  def batch_create 
    # call the batch create method within the meal plan model
    success = MealPlan.batch_create(request.raw_post)
    # return an appropriate response
    respond_to do |format|
	    if success
	    	format.html { redirect_to meal_plans_path, notice: 'recommendations were successfully
	            	 added' }
	      format.json { render json: {success: 'meal plans added'}, status: :created }
	    else
	     format.json { render json: {failed: 'meal plans not added'}, status: :unprocessable_entity }
	    end
	end
  end

	private

	def meal_plan_params
      params.require(:meal_plan).permit(:recipe_id, :meal_date)
    end
end
