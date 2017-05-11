class UsersController < ApplicationController
  before_filter :correct_user, only: [:show, :edit, :update, :destroy]

  #later may allow some access to admins who are not the user
   def charts
    @last_month_active_recipe_data  = Recipe.select("recipes.name").joins(:meals).where('meals.meal_date between ? and ?', 31.days.ago, 1.days.ago).where('active = ?', true).where('recipes.user_id = ?', current_user.id).group("recipes.name").count
    @last_month_inactive_recipe_data  = Recipe.select("recipes.name").joins(:meals).where('meals.meal_date between ? and ?', 31.days.ago, 1.days.ago).where('active = ?', false).where('recipes.user_id = ?', current_user.id).group("recipes.name").count
    @last_month_recipe_count = Recipe.joins(:meals).where('meals.meal_date between ? and ?', 31.days.ago, 1.days.ago).count
    @difficulty_level_last_month = Recipe.select("recipes.name").joins(:meals).where('meals.meal_date between ? and ?', 31.days.ago, 1.days.ago).where('recipes.user_id = ?', current_user.id).group(:difficulty_level).count
    @ingredient_data = Recipe.select("ingredients.name").joins(:ingredients).joins(:meals).where('meals.meal_date between ? and ?', 31.days.ago, 1.days.ago).where(user_id:1,active:true).group("ingredients.name").count
    @food_group_data = FoodGroup.select("food_groups.name").joins(ingredients: [{recipes: :meals}]).where('meals.meal_date between ? and ?', 31.days.ago, 1.days.ago).
    where('recipes.user_id = ? and recipes.active =?', 1, true).group("food_groups.name").count
    @difficulty_data = Recipe.where('user_id = ?', current_user.id).where('active = ?', true).group(:difficulty_level).count
    @ingredient_data = Recipe.joins(:ingredients).where('user_id = ?', current_user.id).where('active = ?', true).group("ingredients.name").count
  
  end

  def test
     @ingredient_data = Recipe.select("ingredients.name").joins(:ingredients).joins(:meals).where('meals.meal_date between ? and ?', 31.days.ago, 1.days.ago).where(user_id:1,active:true).group("ingredients.name").count
    @food_group_data = FoodGroup.select("food_groups.name").joins(ingredients: [{recipes: :meals}]).where('meals.meal_date between ? and ?', 31.days.ago, 1.days.ago).
    where('recipes.user_id = ? and recipes.active =?', 1, true).group("food_groups.name").count
   
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
