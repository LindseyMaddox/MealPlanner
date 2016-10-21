class MealPlansController < ApplicationController
	def index

		# might have to map this to make it to an active record relation
		@meal_plans = MealPlan.order(:meal_date).date_filter(params[:date_filter])
		#last week, 7 days before date to 14 days before date
		@time_period = {"last week" => 7, "two weeks ago" => 14}
	end

	def planner
		@number_of_meals = {"one meal" => 1, "five meals" => 5, "seven meals" => 7}
		@this_week_meals = MealPlan.meal_plan_generator(params[:number_of_meals])
		@this_week_meal_ids = MealPlan.meal_plan_generator_ids(params[:number_of_meals])
									   
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
		#probably should just revert to psat commit
		error = false
		 # call the batch create method within the model
		 meal_plan_batch_params[:meal_plan].each do |m|
		 	m = MealPlan.new
		 	error = true unless m.save
		 end
		
		respond_to do |format|
			if error
		        format.html { render action: "new" }
		        format.json { render json: @meal_plan.errors, status: :unprocessable_entity } 
		    else
		    	format.html { redirect_to @meal_plan, notice: 'meal_plan was successfully created.' }
		        format.json { render json: @meal_plan, status: :created, meal_plan: @meal_plan }
		        format.js
		    end
	    end
	end

	private

#for batch create, meal_plan_batch_params returns unpermitted params either way
#meal_plan_params does not specificy any error just doesn't save the records
#both only return the first item
	def meal_plan_batch_params
	  params.require(:meal_plan).permit(meal_plan: [:recipe_id, :meal_date])
      #params.permit({meal_plan: [:recipe_id, :meal_date] }).require(:meal_plan)
    end

	def meal_plan_params
      params.require(:meal_plan).permit(:recipe_id, :meal_date)
    end
end
