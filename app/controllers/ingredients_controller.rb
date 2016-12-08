class IngredientsController < ApplicationController
	before_action :set_ingredient, only: [:show, :edit, :update, :destroy]
	 before_action :logged_in_user
	 
	def index
		@ingredients = Ingredient.paginate(:page => params[:page], :per_page => 15)
	end

	def show
	end

	def new
		@ingredient = Ingredient.new

		respond_to do |format|
	      format.html # new.html.erb
	      format.json { render json: @ingredient }
	    end
	end

	def edit
	end

	def create
	    @ingredient = Ingredient.new(ingredient_params)


	    respond_to do |format|
	      if @ingredient.save
	        format.html { redirect_to ingredients_path, notice: 'ingredient was successfully created.' }
	        format.json { render json: @ingredient, status: :created, ingredient: @ingredient }
	        format.js
	      else
	        format.html { render action: "new" }
	        format.json { render json: @ingredient.errors, status: :unprocessable_entity }
	      end
	    end
	end


	def update
	    respond_to do |format|
	      if @ingredient.update(ingredient_params)
	        format.html { redirect_to @ingredient, notice: 'ingredient was successfully updated.' }
	        format.json { head :no_content }
	      else
	        format.html { render action: "edit" }
	        format.json { render json: @ingredient.errors, status: :unprocessable_entity }
	      end
	    end
	end

	private
	def ingredient_params
      params.require(:ingredient).permit(:name, :type)
    end

    def set_ingredient
    	@ingredient = Ingredient.find(params[:id])
	end
end
