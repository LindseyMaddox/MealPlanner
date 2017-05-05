class RecipesController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user_recipes, only: [:show, :edit, :update, :destroy]


	def index
		@recipes = Recipe.paginate(:page => params[:page], :per_page => 15).current_user_recipes(current_user)

	end

	def show
		@recipe = Recipe.find(params[:id])
		@times_eaten = Recipe.times_eaten(params[:id])
	end

	def new
		@food_groups = FoodGroup.order(:name)
		@ingredients = Ingredient.order(:name)
		@recipe = Recipe.new

		respond_to do |format|
	      format.html # new.html.erb
	      format.json { render json: @recipe }
	    end
	end

	def edit
		@food_groups = FoodGroup.order(:name)
		@ingredients = Ingredient.order(:name)
		@recipe = Recipe.find(params[:id])
	end

	def create
	     @recipe = current_user.recipes.build(recipe_params)

	    respond_to do |format|
	      if @recipe.save
	        format.html { redirect_to recipes_path, notice: 'recipe was successfully created.' }
	        format.json { render json: @recipe, status: :created, recipe: @recipe }
	      else
	        format.html { render action: "new" }
	        format.json { render json: @recipe.errors, status: :unprocessable_entity }
	      end
	    end
	end


	def update

	    @recipe = Recipe.find(params[:id])

	    respond_to do |format|
	      if @recipe.update(recipe_params)
	        format.html { redirect_to @recipe, notice: 'recipe was successfully updated.' }
	        format.json { head :no_content }
	        format.js 
	      else
	        format.html { render action: "edit" }
	        format.json { render json: @recipe.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def charts
		@difficulty_data = Recipe.where('user_id = ?', current_user.id).where('active = ?', true).group(:difficulty_level).count
		@ingredient_data = Recipe.joins(:ingredients).where('user_id = ?', current_user.id).where('active = ?', true).group("ingredients.name").count
	end

	private
	def recipe_params
      params.require(:recipe).permit(:name, :difficulty_level, { :ingredient_ids => [] }, :user_id, :active)
    end

    def correct_user_recipes
    	id = params[:id]
    	sql = "Select user_id from recipes where user_id = id"
    	@user_id = Recipe.select(:user_id).find(params[:id])
    	evaluate_auth_and_redirect(@user_id)
  end

end