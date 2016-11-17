class MealPlansController < ApplicationController
	def index

		# might have to map this to make it to an active record relation
		@meal_plans = MealPlan.order(:meal_date).date_filter(params[:date_filter])
		#last week, 7 days before date to 14 days before date
		@time_period = {"last week" => 7, "two weeks ago" => 14}
	end

	def planner
		@number_of_meals = {"one meal" => 1, "five meals" => 5, "seven meals" => 7}
		@this_week_meals = MealPlan.meal_plan_generator
		@date_options = MealPlan.set_date_options

		@meal_plan = MealPlan.new
	

		respond_to do |format|
	      format.html # new.html.erb
	      format.json { render json: @meal_plan }
	    end							   
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

 def batch_create_2
   #binding.pry
	#@meal_plans = MealPlan.new(meal_plan_params)
	#@meal_plan_content = JSON.parse(request.raw_post)
	#binding.pry
	  #  @meal_plan_content.each do |meal|
	   #   meal = MealPlan.create(meal)
	    #end
	    #@meal_plans = MealPlan.create(params[:meal_plan])

     MealPlan.create(params[:meal_plan])
        @mealrecords = []
       # save_succeeded = true

      #  params["meal_plan"].each do |meal|
       # 	m = MealPlan.new(meal_plan_params)
		#	
         #   save_succeeded = false unless m.save
          #  @mealrecords << m
        #end

         #respond_to do |format|
           # if save_succeeded
		    #  render json: {success: 'meal plans added'}, status: :created
		    #else
		     # render json: {failed: 'meal plans not added'}, status: :unprocessable_entity 
		    #end


            #if save_succeeded
             #   format.json{ render :json => @mealrecords.to_json ,status: 200 }
            #else
             #   format.json { render json: @mealrecords.errors, status: 404 }
            #end
      	#end

  end

  def batch_create #codeschool version
    # call the batch create method within the student model
  #  binding.pry
   # ordered_keys = request.raw_post.split('&')
    #.collect {|k_v|k_v.split('=').first.to_s }

   # success = MealPlan.batch_create(ordered_keys)

   success = MealPlan.batch_create(request.raw_post)
    # return an appropriate response
    if success
      render json: {success: 'meal plans added'}, status: :created
    else
      render json: {failed: 'meal plans not added'}, status: :unprocessable_entity
    end
  end

	private

#for batch create, meal_plan_batch_params returns unpermitted params either way
#meal_plan_params does not specificy any error just doesn't save the records
#both only return the first item
	def meal_plan_batch_params
		 params.require(:meal_plan).permit( meal_plan: [recipe_id, :meal_date])
      #params.permit({meal_plan: [:recipe_id, :meal_date] }).require(:meal_plan)
    end

	def meal_plan_params
      params.require(:meal_plan).permit(:recipe_id, :meal_date)
    end
end
