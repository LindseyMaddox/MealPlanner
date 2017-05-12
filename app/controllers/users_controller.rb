class UsersController < ApplicationController
  before_filter :correct_user, only: [:show, :edit, :update, :destroy]

  #later may allow some access to admins who are not the user
   def charts
    @last_month_active_recipe_data  = Recipe.recent_recipe_meals(current_user, true)
    @last_month_inactive_recipe_data  = Recipe.recent_recipe_meals(current_user, false)
    @difficulty_level_last_month = Recipe.difficulty_level_of_recent_meals(current_user)
    @food_group_data = FoodGroup.recent_food_groups_in_meals(current_user)
    @difficulty_data = Recipe.current_user_difficulty_of_recipes(current_user)
    @ingredient_data = Recipe.ingredients_in_active_recipes(current_user)
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)

    if @user.save
        log_in @user
        flash[:success] = "Welcome to MealPlanner #{@user.name}!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
