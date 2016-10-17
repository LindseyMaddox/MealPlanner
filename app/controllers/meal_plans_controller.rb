class MealPlansController < ApplicationController
	def index

		# might have to map this to make it to an active record relation
		@meal_plans = MealPlan.order(:meal_date).date_filter(params[:date_filter])
		#last week, 7 days before date to 14 days before date
		@time_period = {"last week" => 7, "two weeks ago" => 14}
	end

	def planner
		@this_week_meals = MealPlan.order(:meal_date).meal_plan_generator
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

	private
	def meal_plan_params
      params.require(:meal_plan).permit(:recipe_id, :meal_date)
    end
	
end
