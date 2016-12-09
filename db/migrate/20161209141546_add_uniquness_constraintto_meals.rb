class AddUniqunessConstrainttoMeals < ActiveRecord::Migration[5.0]
  def change
  	add_index :meals, [:recipe_id, :meal_date], unique: true
  end
end
