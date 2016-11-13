class RecipesController < ApplicationController

	def index
		@recipes = Recipe.order(:name)
	end

	def show
		@recipe = Recipe.find(params[:id])
	end

	def new
		@recipe = Recipe.new

		respond_to do |format|
	      format.html # new.html.erb
	      format.json { render json: @recipe }
	    end
	end

	def edit
		@recipe = Recipe.find(params[:id])
	end

	def create
		#binding.pry
	    @recipe = Recipe.new(recipe_params)


	    respond_to do |format|
	      if @recipe.save
	        format.html { redirect_to recipes_path, notice: 'recipe was successfully created.' }
	        format.json { render json: @recipe, status: :created, recipe: @recipe }
	        format.js
	      else
	        format.html { render action: "new" }
	        format.json { render json: @recipe.errors, status: :unprocessable_entity }
	      end
	    end
	end


	def update
	    @recipe = Recipe.find(params[:id])

	    respond_to do |format|
	      if @recipe.update_(recipe_params)
	        format.html { redirect_to @recipe, notice: 'recipe was successfully updated.' }
	        format.json { head :no_content }
	      else
	        format.html { render action: "edit" }
	        format.json { render json: @recipe.errors, status: :unprocessable_entity }
	      end
	    end
	end

	private
	def recipe_params
      params.require(:recipe).permit(:name, :difficulty_level, :grain_id, :protein_id)
    end


end
