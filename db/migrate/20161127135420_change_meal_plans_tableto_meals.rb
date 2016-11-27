class ChangeMealPlansTabletoMeals < ActiveRecord::Migration[5.0]
  def change
  	rename_table :meal_plans, :meals
  end
end
